require "helper"

describe "Company", :acceptance do
  describe "updating" do
    include AcceptanceHelper
    let(:company) { client.companies.create(name: "Old") }

    context "using client.companies.new" do
      context "with a valid model" do
        before { company.name = "new" }

        context "when saved" do
          it "returns a model" do
            company.save.should be_kind_of PLD::Model::Base
          end

          it "has the new name" do
            company.save
            client.companies.find(company.id).name.should == "new"
          end
        end
      end

      context "with an invalid model" do
        before { company.name = nil }

        context "when saved" do
          it "raises an error" do
            expect { company.save }.to raise_error PipeLineDealer::Error::Connection::Unprocessable
          end
        end
      end
    end
  end
end
