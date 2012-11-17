require "helper"

module PipeLineDealer
  describe CustomField do
    let(:model) { nil }

    describe "decode" do
      context "numeric" do
        before { subject.field_type = "numeric" }

        it "decodes correctly" do
          subject.decode(model, 123).should == 123
        end
      end

      context "text" do
        before { subject.field_type = "text" }

        it "decodes correctly" do
          subject.decode(model, "Moehaha").should == "Moehaha" 
        end
      end

      context "currency" do
        before { subject.field_type = "currency" }

        it "decodes correctly" do
          subject.decode(model, 42).should == 42
        end
      end

      context "dropdown" do
        subject do
          CustomField.new(attributes: { 
            "field_type" => "dropdown", 
            "custom_field_label_dropdown_entries" => [{"id" => 123, "value" => "My Item"}]
          })
        end

        it "decodes correctly" do
          subject.decode(model, 123).should == "My Item"
        end
      end

      context "multi_select" do
        subject do
          CustomField.new(attributes: { 
            "field_type" => "multi_select", 
            "custom_field_label_dropdown_entries" => [{"id" => 123, "value" => "My Item"}]
          })
        end

        it "decodes correctly" do
          subject.decode(model, [123]).should == ["My Item"]
        end
      end

      context "Unkown type" do
        before { subject.field_type = "not-known" }

        it "throws an exception" do
          expect { subject.decode(model, 42) }.to raise_error
        end
      end
    end

    describe "encode" do
      context "numeric" do
        before { subject.field_type = "numeric" }

        it "encodes correctly" do
          subject.encode(model, 123).should == 123
        end
      end

      context "text" do
        before { subject.field_type = "text" }

        it "encodes correctly" do
          subject.encode(model, "Moehaha").should == "Moehaha" 
        end
      end

      context "currency" do
        before { subject.field_type = "currency" }

        it "encodes correctly" do
          subject.encode(model, 42).should == 42
        end
      end

      context "dropdown" do
        subject do
          CustomField.new(attributes: { 
            "field_type" => "dropdown", 
            "custom_field_label_dropdown_entries" => [{"id" => 123, "value" => "My Item"}]
          })
        end

        it "encodes correctly" do
          subject.encode(model, "My Item").should == 123
        end
      end

      context "multi_select" do
        subject do
          CustomField.new(attributes: { 
            "field_type" => "multi_select", 
            "custom_field_label_dropdown_entries" => [{"id" => 123, "value" => "My Item"}]
          })
        end

        it "encodes correctly" do
          subject.encode(model, ["My Item"]).should == [123]
        end
      end

      context "Unkown type" do
        before { subject.field_type = "not-known" }

        it "throws an exception" do
          expect { subject.encode(model, 42) }.to raise_error
        end
      end
    end
  end
end
