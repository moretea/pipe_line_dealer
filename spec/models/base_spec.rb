require "helper"

describe PLD::Model::Base do
  subject { TestModel }

  context "initialization" do
    let(:model) { subject.new(attributes: {name: "Springest"}) }

    it "can access the name by the name method" do
      model.name.should == "Springest"
    end

    it "can access the name by via attributes['name']" do
      model.attributes['name'].should == "Springest"
    end

    it "can access the name by via attributes[:name]" do
      model.attributes[:name].should == "Springest"
    end
  end

  context "setting attributes" do
    let(:model) { subject.new() }
    context "name is set using accessor" do
      before { model.name = "Springest" }

      it "is readable via the accessor" do
        model.name.should == "Springest"
      end
    end
  end
end
