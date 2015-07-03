require "spec_helper"
require "credit_card_processor/money"
require "credit_card_processor/card_number"
require "credit_card_processor/person"
require "credit_card_processor/credit_card_account"

RSpec.describe CreditCardProcessor::CreditCardAccount do

  subject { described_class.new(person: person, card_number: card_number, credit_limit: credit_limit) }

  let(:card_number) { CreditCardProcessor::CardNumber.new(1) }
  let(:balance) { CreditCardProcessor::Money.new(100) }
  let(:credit_limit) { CreditCardProcessor::Money.new(1000) }
  let(:person     ){ CreditCardProcessor::Person.new(first_name: "Tom") }

  describe "::new" do

    it "given a credit_card must respond to_card_number" do
      expect { described_class.new(person: person, card_number: "card number", credit_limit: credit_limit) }
        .to raise_error(NoMethodError, /undefined method `to_card_number/)
    end

    it "given a person must respond name" do
      expect { described_class.new(person: 123, card_number: card_number, credit_limit: credit_limit) }
        .to raise_error(NoMethodError, /undefined method `name' for 123:Fixnum/)
    end

    it "given a credit_limit must respond to_money" do
      expect { described_class.new(person: person, card_number: card_number, credit_limit: 101) }
        .to raise_error(NoMethodError, /undefined method `to_money/)
    end

  end

  describe "#person" do

    it "returns the person`s name" do
      expect(subject.person).to eq(person)
    end

  end

  describe "#card_number" do

    it "returns a credit card object" do
      expect(subject.card_number).to eq(card_number)
    end

  end

  describe "#credit_limit" do

    it "returns the credit_limit" do
      expect(subject.credit_limit).to eq(credit_limit)
    end

  end

  describe "#balance" do

    it "starting balance is zero" do
      expect(subject.balance.to_i).to eq(0)
    end

    it "it can be initialized with a starting balance" do
      subject = described_class.new(person:       person,
                                    card_number:  card_number,
                                    credit_limit: credit_limit,
                                    balance:      CreditCardProcessor::Money.new(100))
      expect(subject.balance.to_i).to eq(100)
    end

  end

  describe "#update_balance" do

    it "return a copy of it`s self" do
      expect(subject.next_account_state.to_hash).to eq(subject.to_hash)
    end

    it "will not be the same object" do
      expect(subject.next_account_state).not_to eq subject
    end

    it "can update balance" do
      expect(subject.next_account_state(CreditCardProcessor::Money.new(99)).balance.to_i).to eq(99)
    end

  end

  describe "#available_credit" do

    subject { described_class.new(person:       person,
                                  card_number:  card_number,
                                  credit_limit: credit_limit,
                                  balance:      balance) }


    context do
      let(:credit_limit) { CreditCardProcessor::Money.new(1000) }
      let(:balance) { CreditCardProcessor::Money.new(100) }
      it { expect(subject.available_credit.to_i).to eq 900 }
    end

    context do
      let(:credit_limit) { CreditCardProcessor::Money.new(1000) }
      let(:balance) { CreditCardProcessor::Money.new(200) }
      it { expect(subject.available_credit.to_i).to eq 800 }
    end

    context do
      let(:credit_limit) { CreditCardProcessor::Money.new(1000) }
      let(:balance) { CreditCardProcessor::Money.new(-70) }
      it { expect(subject.available_credit.to_i).to eq 1000 }
    end

    context do
      let(:credit_limit) { CreditCardProcessor::Money.new(1000) }
      let(:balance) { CreditCardProcessor::Money.new(1000) }
      it { expect(subject.available_credit.to_i).to eq 0 }
    end

    context do
      let(:credit_limit) { CreditCardProcessor::Money.new(1000) }
      let(:balance) { CreditCardProcessor::Money.new(1100) }
      it { expect(subject.available_credit.to_i).to eq -100 }
    end

  end

end