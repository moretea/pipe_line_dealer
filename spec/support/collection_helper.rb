module CollectionHelper
  extend ActiveSupport::Concern

  included do
    include ConnectionHelper
    let(:collection) { PLD::Collection.new(client, klass: TestModel) }
  end
end
