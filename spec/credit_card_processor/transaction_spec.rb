require "spec_helper"
require "credit_card_processor/person"
require "credit_card_processor/transaction"
require "credit_card_processor/credit_card_account"
require "credit_card_processor/money"
require "credit_card_processor/card_number"

RSpec.describe CreditCardProcessor::Transaction do
  let(:person) { CreditCardProcessor::Person.new(first_name: "Tom") }
  let(:initial_account_state) { CreditCardProcessor::CreditCardAccount.new(person:       person,
                                                             card_number:  card_number,
                                                             credit_limit: credit_limit,
                                                             balance:      balance) }
  let(:credit_limit) { CreditCardProcessor::Money.new(1000) }
  let(:card_number) { CreditCardProcessor::CardNumber.new(4111111111111111) }
  let(:balance) { CreditCardProcessor::Money.new(0) }

  describe "::charge" do

    subject { described_class.charge(initial_account_state: initial_account_state, amount: amount) }

    context "positive starting balance" do
      let(:balance) { CreditCardProcessor::Money.new(100) }
      let(:amount) { CreditCardProcessor::Money.new(10) }
      it { expect(subject.next_account_state.available_credit.to_i).to eq 890 }
      it { expect(subject.next_account_state.balance.to_i).to eq 110 }
    end

    context "over paid balance" do
      let(:balance) { CreditCardProcessor::Money.new(-87) }
      let(:amount) { CreditCardProcessor::Money.new(900) }
      it { expect(subject.next_account_state.available_credit.to_i).to eq 187 }
      it { expect(subject.next_account_state.balance.to_i).to eq 813 }
    end

    context "invalid transaction" do
      let(:amount) { CreditCardProcessor::Money.new(1001) }
      it { expect(subject.card_valid?).to eq true }
      it { expect(subject.funds_valid?).to eq false }
      it { expect(subject.errors).to eq(["Insufficient Funds"]) }
    end

    context "invalid card number" do
      let(:card_number) { CreditCardProcessor::CardNumber.new(1234567890123456) }
      let(:amount) { CreditCardProcessor::Money.new(0) }
      it { expect(subject.errors).to eq(["Card number not valid"]) }
    end
  end

  describe "::credit" do

    subject { described_class.credit(initial_account_state: initial_account_state, amount: amount) }

    context "positive starting balance" do
      let(:balance) { CreditCardProcessor::Money.new(100) }
      let(:amount) { CreditCardProcessor::Money.new(10) }
      it { expect(subject.next_account_state.available_credit.to_i).to eq 910 }
      it { expect(subject.next_account_state.balance.to_i).to eq 90 }
    end

    context "over paid balance" do
      let(:balance) { CreditCardProcessor::Money.new(-200) }
      let(:amount) { CreditCardProcessor::Money.new(100) }
      it { expect(subject.next_account_state.available_credit.to_i).to eq 1000 }
      it { expect(subject.next_account_state.balance.to_i).to eq -300 }
    end

    context "invalid card number" do
      let(:card_number) { CreditCardProcessor::CardNumber.new(1234567890123456) }
      let(:amount) { CreditCardProcessor::Money.new(0) }
      it { expect(subject.card_valid?).to eq false }
      it { expect(subject.funds_valid?).to eq true }
      it { expect(subject.errors).to eq(["Card number not valid"]) }
    end
  end
end