require "spec_helper"
require 'tempfile'
require "credit_card_processor/cli"

RSpec.describe CreditCardProcessor::CLI do

  let(:input) {
    File.open(File.join(File.dirname(__FILE__), "../../example_input.txt")).read.split("\n")
  }

  let(:output) { File.open(File.join(File.dirname(__FILE__), "../../example_output.txt")).read }

  describe 'stdin' do

    before do
      stub_const('ARGV', [])
    end

    it "exit typed" do
      allow(described_class).to receive(:get_stdin) { "exit" }
      allow(described_class).to receive(:puts_stdout)
      expect(described_class).to receive(:puts_stdout).with("Type exit to see summary.").with("No commands found.")
      described_class.call
    end

    it "full example" do
      allow(described_class).to receive(:get_stdin).and_return(*input)
      allow(described_class).to receive(:puts_stdout)
      expect(described_class).to receive(:puts_stdout).with("Type exit to see summary.").with(output)
      described_class.call
    end
  end

  describe 'file path via ARGS' do

    let(:file){
      file = Tempfile.new('sample_input')
      str = input
      str.pop
      str = str.join("\n")
      file.write(str)
      file.close
      file
    }

    it do
      stub_const('ARGV', [file.path])
      expect(described_class).to receive(:puts_stdout).with(output)
      described_class.call
    end

    after do
      file.unlink
    end

  end

end