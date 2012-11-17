require "json"
require "active_support/hash_with_indifferent_access"

module PipeLineDealer
  module Model
    class Base
      include Concern::Persistance
      attr_reader :attributes
      attr_reader :id

      def initialize options = {}
        @options       = options
        @persisted     = !!@options[:persisted]
        @collection    = @options[:collection]

        import_attributes! @options[:attributes]
      end

      # TODO : remove check of methode bestaat
      def attributes_for_saving(attributes)
        attributes
      end


      def ==(other)
        if other.kind_of?(self.class)
          other.attributes == self.attributes
        else
          super(other)
        end
      end

      def to_json
        JSON.dump(@attributes)
      end

      def self.attrs *attrs
        if attrs.last.kind_of?(Hash)
          options = attrs.pop
        else
          options = {}
        end

        attrs.each do |attr|
          pld_attr attr, options
        end
      end

      def self.inherited(subklass)
        @attributes ||= {}

        # Copy all attributes to the children.
        @attributes.each do |attr, options|
          subklass.pld_attr attr, options
        end
      end

      def self.pld_attr attr, options = {}
        @attributes ||= {}
        @attributes[attr] = options

        # Getter
        define_method attr do
          @attributes[attr.to_s]
        end

        # Setter
        define_method "#{attr}=".to_sym do |value|
          @attributes[attr.to_s] = value
        end
      end

      def to_s
        "<PipeLineDealer::Model:#{__id__} klass=#{self.class.name} id=#{@id} attributes=#{@attributes.inspect}>"
      end

      protected

      def import_attributes! attributes
        @attributes    = stringify_keys(attributes || {})
        @id            = @attributes.delete(:id)

        # Give subclasses the opportunity to hook in here.
        process_attributes if respond_to?(:process_attributes)

        check_for_non_existent_attributes!
      end

      def model_attribute_name
        self.class.instance_variable_get(:@model_attribute_name) || raise("#{self.class.inspect}::@model_attribute_name is missing!")
      end

      # Recursively converts a hash structure with symbol keys to a hash
      # with indifferent keys
      def stringify_keys original
        result = HashWithIndifferentAccess.new

        original.each do |key, value|
          result[key] = stringify_value(value)
        end

        result
      end

      def stringify_value value
        case value
        when String, Fixnum, NilClass, FalseClass, TrueClass
          return value
        when Hash, HashWithIndifferentAccess
          return stringify_keys(value)
        when Array
          return value.collect { |item| stringify_value(item) }
        else
          raise "Unkown type: #{value.class}"
        end
      end

      def valid_attribute_names
        self.class.instance_variable_get(:@attributes).keys || []
      end

      def check_for_non_existent_attributes!
        attribute_keys = @attributes.keys.collect(&:to_sym)

        invalid_attributes = attribute_keys - valid_attribute_names

        if invalid_attributes.any?
          raise Error::InvalidAttributeName.new(self.class, invalid_attributes.first)
        end
      end
    end
  end
end
