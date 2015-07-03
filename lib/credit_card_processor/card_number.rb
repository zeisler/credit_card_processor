require "luhn"
require "forwardable"

module CreditCardProcessor
  class CardNumber


    def initialize(number)
      @number = number
      freeze
    end

    extend Forwardable
    def_delegators :number, :to_int, :to_i, :to_s

    def valid?
      Luhn.valid?(number)
    end

    def to_card_number
      self
    end

    private
    attr_reader :number

  end
end