require "helper"

describe PipeLineDealer::CustomFields do
  before { pending "TODO" }
  include ConnectionHelper

  class ModelWithCustomFields < PLD::Model::Base
    @collection_url       = "models"
    @model_attribute_name = "model"
    @custom_field_client_method = :model_custom_fields

    attrs :name

    include PLD::CustomFields
  end

  class CustomModelField < PipeLineDealer::CustomField
    @collection_url = "admin/model_custom_field_labels"
  end

  let(:collection) { PLD::Collection.new(client, klass: ModelWithCustomFields) }

  let(:custom_attributes) { {
    "custom_label_90" => 42,
    "custom_label_91" => "Yeah"
  } }

  let(:custom_field_labels) { {
     "entries"=>[
        {
          "id"=>90,
          "name"=>"TheAnswerForEverything",
          "is_required"=>false,
          "field_type"=>"numeric"
        },
        {
          "id"=>91,
          "name"=>"Really?",
          "is_required"=>false,
          "field_type"=>"text"
        }
     ],
     "pagination" => {"page" => 1, "pages" => 1, "per_page" => 2, "total" => 2}
    }
  }

  subject { ModelWithCustomFields.new(collection: collection, persisted: true, attributes: { "id" => 123, name: "Springest", custom_fields: custom_attributes} ) }

  context "reading custom fields" do
    before { client.stub(:model_custom_fields).and_return { PLD::CustomField::Collection.new(client, klass: CustomModelField, cache_key: :custom_field_cache_key) } }

    let(:custom_field_models) do
       custom_field_labels.collect { |label| CustomModelField.new(collection: model_custom_fields, persisted: true, attributes: label) }
    end

    it "fetches the translation map" do
      pending
#      connection.should_receive(:get).once.with("admin/model_custom_field_labels.json", anything()).and_return(custom_field_labels)
      connection.should_receive(:cache).once.with(:custom_field_cache_key).and_return(custom_field_labels)
      subject.custom_fields
    end

   it "translates the custom fields to recognizable labels" do
      connection.should_receive(:get).once.with("admin/model_custom_field_labels.json", anything()).and_return(custom_field_labels)

      subject.custom_fields.should == {
        "TheAnswerForEverything" => 42,
        "Really?" => "Yeah"
      }
    end
  end

  context "storing" do
    before { client.stub(:model_custom_fields).and_return { PLD::CustomField::Collection.new(client, klass: CustomModelField) } }

    it "reposts the correct attributes" do
      expected_attributes = {
        "model" => {
          "name" => "Springest",
          "custom_fields" => custom_attributes
         }
      }

      # TODO: should do this only once!
      connection.should_receive(:get).exactly(4).times.with("admin/model_custom_field_labels.json", anything()).and_return(custom_field_labels)
      connection.should_receive(:put).once.with("models/123.json", expected_attributes)

      subject.save
    end

    let(:updated_custom_attributes) { {
      "custom_label_90" => 43,
      "custom_label_91" => "Whoo"
    } }

    it "posts the correct change" do
      expected_attributes = {
        "model" => {
          "name" => "Springest",
          "custom_fields" => updated_custom_attributes
         }
      }

      # TODO: should do this only once!
      connection.should_receive(:get).exactly(4).times.with("admin/model_custom_field_labels.json", anything()).and_return(custom_field_labels)
      connection.should_receive(:put).once.with("models/123.json", expected_attributes)


      subject.custom_fields["TheAnswerForEverything"] = 43
      subject.custom_fields["Really?"] = "Whoo"
      subject.save
    end
  end
end
