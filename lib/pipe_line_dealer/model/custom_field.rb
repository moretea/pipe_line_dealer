module PipeLineDealer
  class CustomField < Model::Base
    attrs :name, :is_required, :field_type
    attr_reader :dropdown_entries

    def process_attributes
      @dropdown_entries = @attributes.delete(:custom_field_label_dropdown_entries)
    end

    def decode(model, value)
      case field_type
      when "numeric"           then return value
      when "text"              then return value
      when "currency"          then return value
      when "dropdown"          then return decode_dropdown(model, value)
      when "multi_select"      then return decode_multi_select(model, value)
      when "multi_association" then return decode_multi_association(model, value)
      else; raise "Unkown PLD field type! #{field_type.inspect}"
      end
    end

    def encode(model, value)
      case field_type
      when "numeric"           then return value
      when "text"              then return value
      when "currency"          then return value
      when "dropdown"          then return encode_dropdown(model, value)
      when "multi_select"      then return encode_multi_select(model, value)
      when "multi_association" then return encode_multi_association(model, value)
      else; raise "Unkown PLD field type! #{field_type.inspect}"
      end
    end

    protected

    def decode_dropdown(model, id)
      @dropdown_entries.each do |entry|
        return entry["value"] if entry["id"] == id
      end

      raise Error::InvalidAttributeValue.new(model, name, id)
    end

    def encode_dropdown(model, value)
      @dropdown_entries.each do |entry|
        return entry["id"] if entry["value"] == value
      end

      raise Error::InvalidAttributeValue.new(model, name, value)
    end

    def decode_multi_select(model, ids)
      ids.collect do |id|
        decode_dropdown(model, id)
      end
    end

    def encode_multi_select(model, values)
      values.collect do |value|
        encode_dropdown(model, value)
      end
    end

    #TODO: Not implemented yet.
    def decode_multi_association(model, value)
      value
    end

    def encode_multi_association(model, value)
      value
    end
  end
end
