require "spec_helper"
require "credit_card_processor/person"

RSpec.describe CreditCardProcessor::Person do

  subject{described_class.new(first_name: "Tom")}

  describe "name" do

    it "return the person`s name" do
      expect(subject.name).to eq "Tom"
    end

  end

end