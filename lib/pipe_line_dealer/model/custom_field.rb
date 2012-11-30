module PipeLineDealer
  class CustomField < Model::Base
    attrs :name, :is_required, :field_type
    attr_reader :dropdown_entries

    def process_attributes
      @dropdown_entries = @attributes.delete(:custom_field_label_dropdown_entries)
    end

    def coder(model)
      coder_klass = Coder::TYPES[field_type.to_sym]
      if coder_klass.nil?
        raise "Unkown PLD field type! #{field_type.inspect}"
      else
        return coder_klass.new(model, self)
      end
    end

    #TODO: aanroeper aanpassen?
    def decode(model, value)
      coder(model).decode(value)
    end

    def encode(model, value)
      coder(model).encode(value)
    end
  end
end
