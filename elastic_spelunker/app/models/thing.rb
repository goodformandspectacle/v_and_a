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

  def to_param
    id.to_s
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
    fields = keys
    total = fields.size

    filled_out_fields = fields.select {|f| !self[f].blank?}
    filled_out_fields.size.to_f / total
  end

  class << self
    def truncatable_fields
      %w{history_note physical_description descriptive_line public_access_description marks label historical_context_note bibliography attributions_note production_note}
    end

    def client
      #log = Rails.env.development?
      log = nil
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

    def find(id)
      query = Jbuilder.encode do |json|
        json.query do
          json.term do
            json.id id
          end
        end
        json.size 1
      end

      begin
        search_results_hash = query(INDEX_NAME,query)

        rows = search_results_hash.hits.hits.map {|h| h._source}

        if rows.any?
          thing = Thing.new(rows.first)
        end
      rescue Elasticsearch::Transport::Transport::Errors::NotFound
        nil
      end
    end

    def paginate(page=1, per_page=10)
      query = Jbuilder.encode do |json|
        json.size per_page
        json.from per_page * (page-1)
        json.sort do
          json.id "asc"
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

    def with_facet(facet,value,page=1,per_page=10)
      query = Jbuilder.encode do |json|
        json.query do
          json.match do
            json.set! facet.to_sym, value
          end
        end
        json.size per_page
        json.from per_page * (page-1)
        json.sort do
          json.id "asc"
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

    def counts_for_facet(facet)
      query = Jbuilder.encode do |json|
        json.aggs do
          json.facet do
            json.terms do
              json.field facet
              json.size 1000
            end
          end
        end
      end

      begin
        search_results_hash = query(INDEX_NAME,query)

        search_results_hash.aggregations.facet.buckets
      rescue Elasticsearch::Transport::Transport::Errors::NotFound
        nil
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

    def count_with_facet(facet,value)
      query = Jbuilder.encode do |json|
        json.query do
          json.match do
            json.set! facet.to_sym, value
          end
        end
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

    def for_date_graph(params)
      limit = params[:limit] || 5000
      if params[:between]
        range_array = [{field: 'year_start',
                        param: 'gte',
                        value: params[:between].first},
                        {field: 'year_end',
                         param: 'lt',
                         value: params[:between].last}]

        query = Jbuilder.encode do |json|
          json.query do
            json.bool do
              json.must do
                json.array! range_array do |range|
                  json.range do
                    json.set! range[:field] do
                      json.set! range[:param], range[:value]
                    end
                  end
                end
              end
            end
          end
          json.size limit
          json.sort do
            json.year_end 'asc'
          end
        end
      else
        query = Jbuilder.encode do |json|
          json.size limit
          json.sort do
            json.year_end 'asc'
          end
        end
      end

    

      begin
        search_results_hash = query(INDEX_NAME,query)

        rows = search_results_hash.hits.hits.map {|h| h._source}

        things = rows.map {|row| Thing.new(row) }
      rescue Elasticsearch::Transport::Transport::Errors::NotFound
        [nil,0]
      end
    end

  end

end
