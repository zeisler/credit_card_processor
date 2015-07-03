module CreditCardProcessor
  class Money

    def initialize(number)
      @number = if number.respond_to? :to_str
        number.to_str.gsub("$" , "")
      else
        number
      end
      freeze
    end

    def to_money
      self
    end

    def to_s
      "$#{number.to_i}"
    end

    def to_i
      number.to_i
    end

    def -(other)
      self.class.new(to_i - other.to_money.to_i)
    end

    def +(other)
      self.class.new(to_i + other.to_money.to_i)
    end

    private

    attr_reader :number

  end
end