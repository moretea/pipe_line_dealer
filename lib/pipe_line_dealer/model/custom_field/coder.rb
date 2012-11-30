module PipeLineDealer
  class CustomField
    class Coder
      class Base
        def initialize(model, field)
          @model = model
          @field = field
        end
      end

      class Identity < Base
        def encode value
          value
        end

        def decode value
          value
        end
      end

      class Dropdown < Base
        def encode value
          find :value, of: value, and_return: :id
        end

        def decode id
          find :id, of: id, and_return: :value
        end

        protected

        def find key, options
          key        = key.to_s
          value      = options[:of]
          and_return = options[:and_return].to_s

          entry = @field.dropdown_entries.find { |entry| entry[key] == value }
          
          if entry
            return entry[and_return]
          else
            raise Error::InvalidAttributeValue.new(@model, @field.name, value)
          end
        end
      end

      class MultiSelect < Base
        def encode values
          coder = Dropdown.new(@model, @field)
          values.collect { |value| coder.encode(value) }
        end

        def decode ids
          coder = Dropdown.new(@model, @field)
          ids.collect { |value| coder.decode(value) }
        end
      end

      TYPES = {
        numeric: Identity,
        text: Identity,
        currency: Identity,
        dropdown: Dropdown,
        multi_select: MultiSelect,
        multi_assocation: Identity # Does not work yet
      } 
    end
  end
end
