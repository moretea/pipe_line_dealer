module PipeLineDealer
  class Error
    class InvalidAttribute < PipeLineDealer::Error
      attr_reader :attribute_name

      def initialize(klass, attribute_name)
        @klass = klass
        @attribute_name = attribute_name
      end
    end

    class InvalidAttributeName < InvalidAttribute
      def initialize(klass, attribute_name)
        super
        @message = "The attribute #{attribute_name.inspect} is not known by #{klass.inspect}!"
      end
    end

    class InvalidAttributeValue < InvalidAttribute
      attr_reader :value

      def initialize(klass, attribute_name, value)
        super(klass, attribute_name)
        @value = value
        @message = "The attribute #{attribute_name.inspect} does not accept the value #{value.inspect} (on model #{klass.inspect})"
      end
    end
  end
end
