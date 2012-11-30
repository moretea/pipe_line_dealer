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
          entry = @field.dropdown_entries.find { |entry| entry["value"] == value }
          
          if entry
            return entry["id"]
          else
            raise Error::InvalidAttributeValue.new(@model, @field.name, value)
          end
        end

        def decode id
          entry = @field.dropdown_entries.find { |entry| entry["id"] == id }
          
          if entry
            return entry["value"]
          else
            raise Error::InvalidAttributeValue.new(@model, @field.name, id)
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
