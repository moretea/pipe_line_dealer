module PipeLineDealer
  class Client
    class Connection
      attr_accessor :cache

      DEFAULT_OPTIONS = {
        http_debug: false
      }

      def initialize(key, options)
        @key        = key
        @cache      = {}
        @options    = DEFAULT_OPTIONS.merge options
        @connection = build_connection
      end

      def build_connection
        Faraday.new(url: ENDPOINT) do |faraday|
          faraday.request  :url_encoded
          faraday.response :logger if @options[:http_debug]
          faraday.adapter  Faraday.default_adapter
        end
      end

      def cache(key, &block)
        if not @cache.has_key?(key)
          @cache[key] = block.call
        end

        @cache[key]
      end

      # HTTP methods
      [:get, :post, :put, :delete].each do |method|
        class_eval <<-RUBY
          def #{method} url, params = {}
            request(:#{method}, url, params)
          end
        RUBY
      end

      protected

      def request(method, request_url, params)
        begin
          case method
          when :get, :delete
            request_params = params.merge(api_key: @key)
            query = Faraday::Utils.build_nested_query(request_params)
            response = @connection.send(method, request_url + "?" + query)
          when :post, :put
            request_url += "?api_key=#{@key}"
            body = Faraday::Utils.build_nested_query(params)
            response = @connection.send(method, request_url, body)
          end

          if method == :delete
            # Bwelch. Only a delete doesn't return valid json :(
            return [response.status, JSON.parse('{ "msg": "' + response.body + '" }')]
          else
            return [response.status, JSON.parse(response.body)]
          end
        end
      end

      def debug?
        ENV['DEBUG'] == "true"
      end
    end
  end
end
