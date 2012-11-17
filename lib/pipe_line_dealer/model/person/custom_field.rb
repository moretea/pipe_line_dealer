module PipeLineDealer
  class Person
    class CustomField < PipeLineDealer::CustomField
      @collection_url = "admin/person_custom_field_labels"
    end
  end
end
