require "helper"

describe PipeLineDealer::Model::Base::Concern::Persistance do
  include CollectionHelper

  context "routing (url&method)" do
    context "non persisted models" do
      context "build by collection" do
        subject { collection.new }

        it "builds a non persisted model" do
          subject.persisted?.should == false
        end

        it "builds a non persisted model" do
          subject.persisted?.should == false
        end
      end

      context "when saved" do
        subject { collection.new(name: "Springest") }
        after(:each) { subject.save }

        it "uses the POST method" do
          connection.should_receive(:post).and_return([200, {}])
        end

        it "posts to the correct address" do
          connection.should_receive(:post).with("test_models.json", anything).and_return([200, {}])
        end

        it "posts the correct attributes" do
          connection.should_receive(:post).with(anything, "moeha" => { "name" => "Springest" }).and_return([200, {}])
        end
      end
    end

    context "persisted models" do
      subject { TestModel.new(collection: collection, persisted: true, attributes: { "id" => 123, name: "Springest"} ) }
      after(:each) { subject.save }

      it "uses the PUT method" do
        connection.should_receive(:put).and_return([200, {}])
      end

      it "posts to the correct address" do
        connection.should_receive(:put).with("test_models/123.json", anything).and_return([200, {}])
      end

      it "posts the correct attributes" do
        connection.should_receive(:put).with(anything, "moeha" => { "name" => "Springest" }).and_return([200, {}])
      end
    end
  end
end
