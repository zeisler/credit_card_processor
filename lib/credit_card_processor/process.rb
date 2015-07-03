module CreditCardProcessor
  class Process

    def process(input)
      input.each { |r| process_row(r) }
      self
    end

    def output(debug=false)
      @accounts.sort.to_h.map { |name, account| name_balance(account, name, debug) }.join("\n")
    end

    private

    def process_row(r)
      args = r.split(" ")
      if args.first.downcase == "add"
        create_account(args)
      else
        create_transaction(args)
      end
    end

    def create_transaction(args)
      command, first_name, amount_str = args
      amount                          = CreditCardProcessor::Money.new(amount_str)
      transactions[first_name]        ||= []
      transaction                     = CreditCardProcessor::Transaction.public_send(command.downcase,
                                                                                     { initial_account_state: accounts[first_name],
                                                                                       amount:  amount })
      transactions[first_name] << transaction
      if transaction.funds_valid?
        accounts[first_name] = transactions[first_name].last.next_account_state
      end
    end

    def create_account(args)
      _, first_name, card_number_string, credit_limit_str = args
      person                                              = CreditCardProcessor::Person.new(first_name: first_name)
      card_number                                         = CreditCardProcessor::CardNumber.new(card_number_string)
      credit_limit                                        = CreditCardProcessor::Money.new(credit_limit_str)
      accounts[first_name]                                = CreditCardProcessor::CreditCardAccount.new(person:       person,
                                                                                                       card_number:  card_number,
                                                                                                       credit_limit: credit_limit)
    end

    def name_balance(account, name, debug)
      if transactions[name].all?(&:card_valid?)
        "#{name}: #{account.balance}"
      else
        error_message = error_message(debug, name)
        "#{name}: #{error_message}"
      end
    end

    def error_message(debug, name)
      if debug
        transactions[name].map(&:errors)
      else
        "error"
      end
    end

    def accounts
      @accounts ||= {}
    end

    def transactions
      @transactions ||= {}
    end

  end
end