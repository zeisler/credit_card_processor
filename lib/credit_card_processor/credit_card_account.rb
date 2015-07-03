module CreditCardProcessor
  class CreditCardAccount

    attr_reader :person, :card_number, :credit_limit, :balance

    def initialize(person:, card_number:, credit_limit:, balance: Money.new(0))
      person.name # interface check
      @person       = person
      @card_number  = card_number.to_card_number
      @credit_limit = credit_limit.to_money
      @balance      = balance.to_money
      freeze
    end

    def to_hash
      {
        person:       person,
        card_number:  card_number,
        credit_limit: credit_limit,
        balance:      balance
      }
    end

    def next_account_state(new_balance=balance)
      self.class.new(to_hash.merge!(balance: new_balance))
    end

    def available_credit
      return credit_limit if balance.to_i < 0
      Money.new(credit_limit.to_i - balance.to_i)
    end

  end
end