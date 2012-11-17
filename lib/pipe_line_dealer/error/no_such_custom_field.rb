module PipeLineDealer
  class Error
    class NoSuchCustomField < PipeLineDealer::Error
      attr_reader :name

      def initialize(name)
        @name = name
        @message = "Could not find a custom field with the name #{name.inspect}"
      end
    end
  end
end
