module PipeLineDealer
  class CustomField
    class Collection < PipeLineDealer::Collection
      def initialize(client, options={})
        options[:cached] = true
        super(client, options)
      end

      def [](key)
        self.all.each do |item|
          return item if item.name== key
        end

        raise PipeLineDealer::Error::NoSuchCustomField.new(key)
      end
    end
  end
end
