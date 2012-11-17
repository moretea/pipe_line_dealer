module PipeLineDealer
  class Person < Model::Base
    @collection_url             = "people"
    @model_attribute_name       = "person"
    @custom_field_client_method = :custom_person_fields

#    include CustomFields

    attrs :company, :company_id, :company_name, :created_at, :deal_ids, :deals, :email, :email2, :facebook_url, :fax, :first_name, :full_name, :home_address_1, :home_address_2, :home_city, :home_country, :home_email, :home_phone, :home_postal_code, :home_state, :image_thumb_url, :instant_message, :last_name, :lead_source, :lead_status, :linked_in_url, :mobile, :phone, :position, :predefined_contacts_tag_ids, :predefined_contacts_tags, :total_pipeline, :twitter, :type, :updated_at, :user, :user_id, :viewed_at, :website, :won_deals_total, :work_address_1, :work_address_2, :work_city, :work_country, :work_postal_code, :work_state

    def process_attributes
      @attributes.delete(:custom_fields)
    end

    #TODO: make sure that removeing one of these causes problems.
    def attributes_for_saving_with_person attributes
      attributes = attributes_for_saving_without_person(attributes)

      attributes.delete(:company)
      attributes.delete(:deals)
      attributes.delete(:won_deals_total)
      attributes.delete(:lead_status)
      attributes.delete(:viewed_at)
      attributes.delete(:deal_ids)
      attributes.delete(:predefined_contacts_tag_ids)
      attributes.delete(:user_id)
      attributes.delete(:user)

      attributes.delete(:image_thumb_url) if attributes[:image_thumb_url] == "/images/thumb/missing.png"

      attributes
    end

    alias_method_chain :attributes_for_saving, :person
  end
end
