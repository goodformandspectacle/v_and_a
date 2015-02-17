require 'elasticsearch'
require 'elasticsearch'
require 'jbuilder'
require 'hashie'
require 'typhoeus'
require 'typhoeus/adapters/faraday'

class Thing
  INDEX_NAME = 'va_things'
  attr_reader :original_hash

  def initialize(hash)
    @original_hash = hash
  end

  def method_missing(m, *args, &block)
    if @original_hash
      @original_hash.send(m, *args, &block)
    end
  end

  def accession_year
    if museum_number[-4..-1].to_s =~ /\d{4}/
      y = museum_number[-4..-1].to_i
      if (y > 1840) && (y < 2015)
        y
      else
        nil
      end
    end
  end

  def accession_year_valid?
    (accession_year =~ /\d{4}/) != nil
  end

  def api_path
    "http://www.vam.ac.uk/api/json/museumobject/#{object_number}"
  end

  def has_image?
    !primary_image_id.blank?
  end

  def image_url(size=nil)
    if primary_image_id != ""
      sizes = {small: 's',
               medium: 'm',
               square: 'ds',
               large: 'l'}
      if size
        size_suffix = "_jpg_#{sizes[size]}"
      else
        size_suffix = ""
      end
      # http://media.vam.ac.uk/media/thira/collection_images/2009BX/2009BX7717_jpg_l.jpg 
      "http://media.vam.ac.uk/media/thira/collection_images/#{primary_image_id[0,6]}/#{primary_image_id}#{size_suffix}.jpg"
    end
  end

  def completeness
    fields = Thing.attribute_names
    total = fields.size

    filled_out_fields = fields.select {|f| !self[f].blank?}
    filled_out_fields.size.to_f / total
  end

  class << self
    def truncatable_fields
      %w{history_note physical_description descriptive_line public_access_description marks label historical_context_note bibliography attributions_note production_note}
    end

    def client
      log = Rails.env.development?
      Elasticsearch::Client.new log: log, 
        host: "localhost:9200",
        transport_options: {
          request: { timeout: 30 }
        }
    end

    def query(index, query)
      search_results = client.search(index: index, body: query)
      Hashie::Mash.new(search_results)
    end

    def total_pages_for_results(results, per_page)
      total_hits = results.hits.total
      (total_hits.to_f/per_page).ceil
    end

    def find
      # TODO
    end

    def paginate(page=1, per_page=10)
      query = Jbuilder.encode do |json|
        json.size per_page
        json.from per_page * (page-1)
        json.sort do
          json.object_number "desc"
        end
      end

      begin
        search_results_hash = query(INDEX_NAME,query)

        rows = search_results_hash.hits.hits.map {|h| h._source}

        things = rows.map {|row| Thing.new(row) }

        total_pages = total_pages_for_results(search_results_hash, per_page)

        [things, total_pages]
      rescue Elasticsearch::Transport::Transport::Errors::NotFound
        [nil,0]
      end
    end

    def count_all
      query = Jbuilder.encode do |json|
        json.size 10
        json.from 0
      end

      begin
        search_results_hash = query(INDEX_NAME,query)
        search_results_hash['hits']['total']
      rescue Elasticsearch::Transport::Transport::Errors::NotFound
        0
      end
    end

  end

end
