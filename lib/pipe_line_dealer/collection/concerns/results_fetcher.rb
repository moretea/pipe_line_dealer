module PipeLineDealer
  class Collection
    module Concerns
      class ResultsFetcher
        attr_reader :options

        def initialize(collection, options)
          @collection = collection
          @options = options
        end

        def limit 
          options[:limit] || PipeLineDealer::Limits::MAX_RESULTS_PER_PAGE
        end

        def each &block
          @params =  { page: 1, per_page: PipeLineDealer::Limits::MAX_RESULTS_PER_PAGE }

          @results_yielded = 0

          # Enforce maximum number of resulst per page.
          if limit && limit > PipeLineDealer::Limits::MAX_RESULTS_PER_PAGE
            options[:limit] = PipeLineDealer::Limits::MAX_RESULTS_PER_PAGE
          end

          @params[:per_page] = limit

          #TODO: refactor this deal specific piece of code.
          if options.has_key?(:where) && options[:where].has_key?(:query) && options[:where][:query].has_key?(:company_id)
            @params[:company_id] = options[:where][:query][:company_id].to_s
          end

          catch :stop_yielding do
            while true
              status, result = @collection.client.connection.get(@collection.collection_url + ".json", @params)

              if status == 200
                yield_results(result, &block)
              else # status != 200
                #TODO
                raise "Unexpected status #{status.inspect}"
              end
            end
          end
        end

        def yield_results result, &block
          result["entries"].each do |entry|
            block.call(@collection.klass.new(collection: @collection, persisted: true, attributes: entry))
            @results_yielded += 1

            throw :stop_yielding if @results_yielded >= limit
          end

          if result["pagination"]["page"] < result["pagination"]["pages"]
            @params[:page] += 1
          else
            throw :stop_yielding
          end
        end
      end
    end
  end
end
