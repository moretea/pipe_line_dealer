module PipeLineDealer
 class Company < Model::Base
    @collection_url       = "companies"
    @model_attribute_name = "company"
    @custom_field_client_method = :custom_company_fields

    include CustomFields

    attrs :address_1, :address_2, :city, :country,
      :name,  :description,
      :image_thumb_url,
      :import_id,
      :email, :fax, :phone1, :phone1_desc, :phone2, :phone2_desc, :phone3, :phone3_desc, :phone4, :phone4_desc, :postal_code, :state, :web,
      :total_pipeline, :won_deals_total,
      :created_at, :updated_at


    def attributes_for_saving_with_company attributes
      attributes = attributes_for_saving_without_company(attributes)

      attributes.delete(:total_pipeline)
      attributes.delete(:won_deals)
      attributes.delete(:won_deals_total)
      attributes.delete(:image_thumb_url) if attributes[:image_thumb_url] == "/images/thumb/missing_company.png"

      attributes
    end

    alias_method_chain :attributes_for_saving, :company

    def notes
      Collection.new(@collection.client, klass: Note, cached: false).\
        where(query: { company_id: self.id }).\
        on_new_defaults(company_id: self.id)
    end
  end
end
