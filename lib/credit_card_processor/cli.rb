module CreditCardProcessor
  class CLI

    def self.call
      if ARGV.empty?
        rows = []
        puts_stdout "Type exit to see summary."
        while (input = get_stdin).downcase != "exit"
          rows << input
        end
        if rows.count < 1
          puts_stdout "No commands found."
        else
          puts_stdout CreditCardProcessor::Process.new.process(rows).output
        end
      else
        file = File.open(ARGV.first)
        puts_stdout CreditCardProcessor::Process.new.process(file.read.split("\n")).output
      end

    end

    private

    def self.get_stdin
      gets.chomp
    end

    def self.puts_stdout(str)
      puts str
    end

  end
end