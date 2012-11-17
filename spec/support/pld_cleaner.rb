module PLDCleaner
  extend self

  COLLECTION_NAMES = [:companies, :people]

  def clean!(client)
    COLLECTION_NAMES.each do |collection_name|
      collection = client.send(collection_name)

      collection.each do |model|
        #CRITICAL
        model.destroy || raise("Could not remove #{model.inspect}")
      end
    end
  end
end
