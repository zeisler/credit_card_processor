require "spec_helper"
require "credit_card_processor/money"

RSpec.describe CreditCardProcessor::Money do

  subject{ described_class.new(1) }

  it "takes a string with $" do
    expect(described_class.new("$989").to_i).to eq 989
  end

  describe "#to_money" do


    it "will return self" do
      expect(subject.to_money).to eq subject
    end

  end

  describe "#to_s" do

    it "convert to a string" do
      expect(subject.to_s).to eq("$1")
    end

  end

  describe "#to_i" do

    it "converts to a integer" do
      expect(subject.to_i).to eq(1)
    end

  end

  describe "#-" do

    it do
      result = described_class.new(10) - described_class.new(1)
      expect(result.to_money.to_i).to eq(9)
    end

  end

  describe "#+" do

    it do
      result = described_class.new(10) + described_class.new(1)
      expect(result.to_money.to_i).to eq(11)
    end

  end

end