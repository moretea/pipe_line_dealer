require "helper"

describe "Company", :acceptance do
  describe "creation" do
    include AcceptanceHelper

    context "using client.companies.new" do
      let(:company) { client.companies.new(name: "Meh") }

      context "with a valid model" do
        before { company.name = "Meh" }

        context "when saved" do
          it "returns a model" do
            company.save.should be_kind_of PLD::Model::Base
          end
        end
      end

      context "with an invalid model" do
        before { company.name = nil }

        context "when saved" do
          it "raises an error" do
            expect { company.save}.to raise_error PipeLineDealer::Error::Connection::Unprocessable
          end
        end
      end
    end
  end
end
