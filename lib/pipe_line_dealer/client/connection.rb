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
      {get: :get_style, post: :post_style, put: :post_style, delete: :get_style}.each do |name, style|
        class_eval <<-RUBY
          def #{name} url, params = {}
            request_#{style}(:#{name}, url, params)
          end
        RUBY
      end

      protected


      # get / delete
      def request_get_style method, request_url, params
        request_params = params.merge(api_key: @key)
        query = Faraday::Utils.build_nested_query(request_params)
        server_response = @connection.send(method, request_url + "?" + query)

        # Bwelch. Only a delete doesn't return valid json :(
        raw = (method == :delete)

        build_response_from server_response, raw: raw
      end

      # post / put
      def request_post_style method, request_url, params
        request_url += "?api_key=#{@key}"
        request_body = Faraday::Utils.build_nested_query(params)
        build_response_from @connection.send(method, request_url, request_body)
      end

      DEFAULT_REQUEST_OPTIONS = { raw: false }

      def build_response_from response, options = DEFAULT_REQUEST_OPTIONS
        if options[:raw]
          return [response.status, JSON.parse('{ "msg": "' + response.body + '" }')]
        else
          return [response.status, JSON.parse(response.body)]
        end
      end

      def debug?
        ENV['DEBUG'] == "true"
      end
    end
  end
end
