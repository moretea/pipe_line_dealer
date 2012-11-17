module PipeLineDealer
  module Model
    class Base
      module Concern
        module Persistance
          include ActiveSupport::Concern

          def new_record?
            not @persisted
          end

          def persisted?
            @persisted
          end

          IGNORE_ATTRIBUTES_WHEN_SAVING = [:updated_at, :created_at]

          def save
            # Use :post for new records, :put for existing ones
            method = new_record? ? :post : :put

            # Ignore some attributes
            save_attrs = @attributes.reject { |k, v| IGNORE_ATTRIBUTES_WHEN_SAVING.member?(k) }

            # And allow a model class to modify / edit attributes even further
            if respond_to?(:attributes_for_saving)
              save_attrs = attributes_for_saving(save_attrs)
            end

            # Execute the request
            status, response = @collection.client.connection.send(method, object_url, model_attribute_name => save_attrs)

            if status == 200
              import_attributes!(response) # Set the stuff.
              self
            elsif status == 422
              errors = response.collect { |error| { field: error["field"], message: error["msg"] } }
              raise Error::Connection::Unprocessable.new(errors)
            else
              raise "Unexepcted response status #{status.inspect}"
            end
          end

          def destroy
            status, response = @collection.client.connection.send(:delete, object_url)
            #TODO: Check response

            if status == 200 && response["msg"] == " "
              @destroyed = true #todo: store that this model has been destroyed.
              true
            else
              false
            end
          end

          protected

          def object_url
            if persisted?
              @collection.send(:collection_url) + "/" + self.id.to_s + ".json"
            else
              @collection.send(:collection_url) + ".json"
            end
          end
        end
      end
    end
  end
end
