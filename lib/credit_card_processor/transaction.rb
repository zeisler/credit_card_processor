require "ostruct"

module CreditCardProcessor
  class Transaction

    def self.charge(**args)
      self.new(args.merge!(command: __method__))
    end

    def self.credit(**args)
      self.new(args.merge!(command: __method__))
    end

    def initialize(command:, initial_account_state:, amount:)
      @initial_account = initial_account_state
      @amount          = amount
      @command         = command
      freeze
    end

    def next_account_state
      @initial_account.next_account_state(@initial_account.balance.send(operator, @amount))
    end

    def card_valid?
      next_account_state.card_number.valid?
    end

    def funds_valid?
      next_account_state.available_credit.to_i > 0
    end

    def errors
      [
        ["Card number not valid", card_valid?],
        ["Insufficient Funds", funds_valid?]
      ].reject do |_, bool|
        bool
      end.map { |msg, bool| msg }
    end

    private

    def operator
      { charge: :+, credit: :- }[@command]
    end

  end
end