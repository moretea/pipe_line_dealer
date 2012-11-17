require "helper"

describe PLD::Collection do
  include ConnectionHelper

  subject { PLD::Collection.new(client, klass: TestModel) }

  context "transparant pagination" do
    let(:expected_params_a) { ["test_models.json", { page: 1, per_page: 200 } ] }
    let(:expected_params_b) { ["test_models.json", { page: 2, per_page: 200 } ] }

    let(:response_a) do
      [
        200, # Status code
        {    # 'JSON' body
          "pagination" => {
            "page"      => 1,
            "pages"     => 2,
            "per_page"  => 1,
            "total"     => 2,
            "url"       => '/resource',
          },
          "entries" => [model_a.attributes]
        }
      ]
    end

    let(:response_b) do
      [
        200, # Status code
        {    # 'JSON' body
          "pagination" => {
            "page"      => 2,
            "pages"     => 2,
            "per_page"  => 1,
            "total"     => 2,
            "url"       => '/resource',
          },
          "entries" => [model_b.attributes]
        }
      ]
    end

    let(:model_a) { TestModel.new(collection: subject, attributes: { name: "Maarten" }) }
    let(:model_b) { TestModel.new(collection: subject, attributes: { name: "Hoogendoorn" }) }

    it "fetches the correct models" do
      connection.should_receive(:get).ordered.once.with(*expected_params_a).and_return(response_a)
      connection.should_receive(:get).ordered.once.with(*expected_params_b).and_return(response_b)

      subject.all.to_a.should =~ [model_a, model_b]
    end

    it "returns records that are not new" do
      connection.should_receive(:get).ordered.once.with(*expected_params_a).and_return(response_a)
      connection.should_receive(:get).ordered.once.with(*expected_params_b).and_return(response_b)

      a, b = subject.all.to_a

      a.new_record?.should == false
      b.new_record?.should == false
    end
  end

  context "limit" do
    let(:expected_params) { ["test_models.json", { page:1, per_page: 1} ] }

    let(:response) do
      [
        200, # Status code
        {    # 'JSON' body
          "pagination" => {
             "page"      => 1,
             "pages"     => 2,
             "per_page"  => 1,
             "total"     => 2,
             "url"       => '/resource',
           },
          "entries" => [model_a.attributes]
        }
      ]
    end

    let(:model_a) { TestModel.new(collection: subject, attributes: { name: "Maarten"}) }

    it "fetches only the resouces before the limit" do
      connection.should_receive(:get).once.with(*expected_params).and_return(response)
      subject.first.should == model_a
    end
  end

  describe "cacheing" do
    let(:response) do
      [
        200, # Status code
        {
          "pagination" => {
             "page"      => 1,
             "pages"     => 1,
             "per_page"  => 1,
             "total"     => 1,
             "url"       => '/resource',
           },
          "entries" => [{}]
        }
      ]
    end

    before do
      connection.stub(:get).and_return(response)
    end

    context "not cached" do
      subject { PLD::Collection.new(client, klass: TestModel, cached: false) }

      it "doesn't try to cache the result" do
        connection.should_not_receive(:cache)
        subject.all.to_a
      end
    end

    context "cached" do
      subject { PLD::Collection.new(client, klass: TestModel, cached: true) }

      it "caches the request" do
        connection.should_receive(:cache)
        subject.all
      end
    end
  end

  context "building new objects" do
    let(:new_object) { subject.new }

    it "builds a model" do
      new_object.should be_kind_of TestModel
    end

    context "initialize these objects" do
      include CollectionHelper
      subject { collection }

      context "valid attributes" do
        it "sets the valid attributes" do
          model = collection.new(name: "Springest")
          model.name.should == "Springest"
        end
      end

      context "invalid attributes" do
        context "invalid name" do
          it "raises an exception" do
            expect { collection.new(no_such_name: "Springest") }.to raise_error(PLD::Error::InvalidAttributeName)
          end
        end

        context "invalid value" do
          it "raises an exception" do
            pending "TODO"
            expect { collection.new(name: "Springest") }.to raise_error(PLD::Error::InvalidAttributeValue)
          end
        end
      end
    end
  end
end
