require 'elasticsearch'
require 'elasticsearch'
require 'jbuilder'
require 'hashie'
require 'typhoeus'
require 'typhoeus/adapters/faraday'

class Thing
  INDEX_NAME = 'va_things'

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

        total_pages = total_pages_for_results(search_results_hash, per_page)

        [rows, total_pages]
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
