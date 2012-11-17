module PipeLineDealer
  class Collection
    module Concerns
      module CreateAndUpdate
        extend ActiveSupport::Concern

        def create(attributes = {})
          if @options[:new_defaults]
            attributes = @options[:new_defaults].merge(attributes)
          end

          @klass.new(collection: self, record_new: true, attributes: attributes).save
        end

        def new(attributes = {})
          if @options[:new_defaults]
            attributes = @options[:new_defaults].merge(attributes)
          end

          @klass.new(collection: self, record_new: true, attributes: attributes)
        end
      end
    end
  end
end
