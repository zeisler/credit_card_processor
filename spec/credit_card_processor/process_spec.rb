require "credit_card_processor"

RSpec.describe CreditCardProcessor::Process do

  describe "::process" do

    let(:input) {
      _input = File.open(File.join(File.dirname(__FILE__), "../../example_input.txt")).read.split("\n")
      _input.pop
      _input
    }

    let(:output) { File.open(File.join(File.dirname(__FILE__), "../../example_output.txt")).read }

    it "string input" do
      expect(subject.process(input).output).to eq(output)
    end

  end

end