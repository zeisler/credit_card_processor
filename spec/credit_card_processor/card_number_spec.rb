require "spec_helper"
require "credit_card_processor/card_number"

RSpec.describe CreditCardProcessor::CardNumber do
  # I am a validator and display converter for the concept of a credit card
  describe "to_card_number" do

    subject{ described_class.new(1) }

    it "returns it`s self" do
      expect(subject.to_card_number).to eq(subject)
    end

  end

  describe "#to_int" do

    it "has an identity of an int" do
      expect(described_class.new(1).to_int).to eq(1)
    end

  end

  describe "#to_i" do

    it "can be represented at an integer" do
      expect(described_class.new(1).to_i).to eq(1)
    end

  end

  describe "#to_s" do

    it "can be converted to a string" do
      expect(described_class.new(1).to_s).to eq("1")
    end

  end
  describe "#valid" do

    it "return true when it passes luhn" do
      expect(described_class.new(4111111111111111).valid?).to eq true
    end

    it "return false when it fails luhn" do
      expect(described_class.new(1234567890123456).valid?).to eq false
    end

  end

end