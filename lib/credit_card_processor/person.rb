module CreditCardProcessor
  class Person

    def initialize(first_name:)
      @first_name = first_name
      freeze
    end

    def name
      first_name
    end

    private

    attr_reader :first_name
  end
end