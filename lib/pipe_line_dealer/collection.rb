module PipeLineDealer
  class Collection
    include Concerns::Fetching
    include Concerns::CreateAndUpdate

    DEFAULT_OPTIONS = { cached: false }

    attr_reader :client
    attr_reader :klass
    def initialize(client, options = {})
      @options = DEFAULT_OPTIONS.merge(options)
      @client = client
      @klass  = options[:klass]
    end

    def to_s
      "<PipeLineDealer::Collection:#{__id__} @klass=#{@klass.inspect}>"
    end

    def collection_url
      @klass.instance_variable_get(:@collection_url)
    end
  end
end
