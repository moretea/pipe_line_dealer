require "helper"

describe "Person", :acceptance do
  describe "creation" do
    include AcceptanceHelper

    context "using client.people.new" do
      let(:person) { client.people.new(first_name: "Maarten", last_name: "Hoogendoorn") }

      before { person.first_name = "MoreTea" }

      context "when saved" do
        it "returns a model" do
          person.save.should be_kind_of PLD::Model::Base
        end
      end
    end
  end
end
