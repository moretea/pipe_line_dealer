module PipeLineDealer
  class Collection
    module Concerns
      class ResultsFetcher
        attr_reader :options

        # This struct captures the state we need to implement an transparent API
        Cursor = Struct.new(:params, :results_yielded, :done)

        def initialize(collection, options)
          @collection = collection
          @options    = options
        end

        def each &block
          cursor = Cursor.new(build_params, 0, false)

          while not cursor.done
            status, result = @collection.client.connection.get(@collection.collection_url + ".json", cursor.params)

            if status == 200
              yield_results(cursor, result, &block)
            else
              raise "Unexpected status #{status.inspect}" #TODO: Nicer exception
            end
          end
        end

        protected

        def build_params
          params = { page: 1, per_page: PipeLineDealer::Limits::MAX_RESULTS_PER_PAGE }

          # Enforce maximum number of resulst if limit is smaller than the max results per page.
          if options[:limit] && options[:limit] < PipeLineDealer::Limits::MAX_RESULTS_PER_PAGE
            params[:per_page] = options[:limit]
          end

          # Additional condition.
          #TODO: refactor?
          if options.has_key?(:where) && options[:where].has_key?(:query) && options[:where][:query].has_key?(:company_id)
            params[:company_id] = options[:where][:query][:company_id].to_s
          end

          params
        end

        def yield_results cursor, result, &block
          result["entries"].each do |entry|
            block.call(@collection.klass.new(collection: @collection, persisted: true, attributes: entry))
            cursor.results_yielded += 1

            # Have we reached the limit?
            if options[:limit] && cursor.results_yielded >= options[:limit]
              cursor.done = true
              return
            end
          end

          # Are we on the last page?
          if result["pagination"]["page"] < result["pagination"]["pages"]
            # No, go to next page
            cursor.params[:page] += 1
          else
            # Yes, we're done
            cursor.done = true
          end
        end
      end
    end
  end
end
