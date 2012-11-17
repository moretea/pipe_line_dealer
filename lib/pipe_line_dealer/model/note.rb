module PipeLineDealer
  class Note < Model::Base
    @collection_url             = "notes"
    @model_attribute_name       = "note"

#    include CustomFields

    @custom_field_client_method = :custom_person_fields
    attrs :deal, :deal_id, :person_id, :company_id, :title, :created_by_user_id, :note_category_id, :created_at, :updated_at, :company, :person, :created_by_user, :note_category, :content

    def process_attributes
      # TODO: Remove these convenience objects for now
    end

    def attributes_for_saving_with_note attributes
      attributes = attributes_for_saving_without_note(attributes)

      attributes.delete(:deal)
      attributes.delete(:created_by_user)
      attributes.delete(:note_category)

      attributes.delete(:created_at)
      attributes.delete(:updated_at)
      attributes.delete(:company)
      attributes.delete(:person)

      attributes
    end

    alias_method_chain :attributes_for_saving, :note
  end
end
