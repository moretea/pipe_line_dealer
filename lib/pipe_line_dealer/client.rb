module PipeLineDealer
  ENDPOINT = "https://api.pipelinedeals.com/api/v3/"

  class Client
    attr_reader :connection

    def initialize(api_key, options = {})
      @connection = Connection.new(api_key, options)
    end

    def companies
      Collection.new(self, klass: Company)
    end

    def custom_company_fields
      CustomField::Collection.new(self, klass: Company::CustomField)
    end

    def people
      Collection.new(self, klass: Person)
    end

    def custom_person_fields
      CustomField::Collection.new(self, klass: Person::CustomField)
    end
  end
end
