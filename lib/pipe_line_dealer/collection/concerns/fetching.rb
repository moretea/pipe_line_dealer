module PipeLineDealer
  class Collection
    module Concerns
      module Fetching
        extend ActiveSupport::Concern

        def where(opts)
          new_options = @options.merge(where: opts)
          self.class.new(@client, new_options)
        end

        def on_new_defaults(opts)
          new_options = @options.merge(new_defaults: opts)
          self.class.new(@client, new_options)
        end

        def all
          if @options[:cached]
            @client.connection.cache(@options[:cache_key]) { self.to_a }
          else
            self
          end
        end

        def limit(lmt)
          refine(limit: lmt)
        end

        def first
          self.limit(1).to_a.first
        end

        def to_a
          array = []
          self.each { |item| array << item }

          array
        end

        def each &block
          options = @options.dup
          ResultsFetcher.new(self, options).each &block
        end

        #TODO: Not speced
        def find id
          status, result = @client.connection.get(collection_url + "/#{id}.json", {})
          if status == 200
            @klass.new(collection: self, persisted: true, attributes: result)
          else
            raise Error::NotFound
          end
        end

        protected

        # Refine the criterea
        def refine(refinements)
          self.class.new(@client, @options.merge(refinements))
        end
      end
    end
  end
end
