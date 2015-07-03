require "spec_helper"

describe CreditCardProcessor do
  it "has a version number" do
    expect(CreditCardProcessor::VERSION).not_to be nil
  end

  describe "::new" do

    it "takes a command, a person, a credit card number and an amount" do
      CreditCardProcessor
    end

  end
end
