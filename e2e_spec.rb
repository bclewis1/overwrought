# frozen_string_literal: true

require 'open3'
require_relative 'spec/test'

RSpec.describe 'Running the options parser' do
  before do
    @stdout, @stderr, status = Open3.capture3("./parser.rb #{arg_string}")
    @status = status.exitstatus
  end

  context 'with verbose, strict mode, and an invalid ip' do
    let(:arg_string) { "#{Test.fixture('invalid_ip.log')} -vs" }

    it 'prints a warning' do
      expect(@status).to eq 0
      expect(@stdout).to match(/warning/)
    end
  end

  context 'with verbose and an invalid ip' do
    let(:arg_string) { "#{Test.fixture('invalid_ip.log')} -v" }

    it 'does not print a warning' do
      expect(@status).to eq 0
      expect(@stdout).not_to match(/warning/)
    end
  end

  context 'without unique-page-views' do
    let(:arg_string) { "#{Test.fixture('happy_one_user.log')} --views traffic-counter" }

    it 'does not print a warning' do
      expect(@status).to eq 0
      expect(@stdout).to match(/Traffic to each uri/)
      expect(@stdout).not_to match(/Unique visits to each uri/)
    end
  end

  context 'without traffic-counter' do
    let(:arg_string) { "#{Test.fixture('happy_one_user.log')} --views unique-page-views" }

    it 'does not print a warning' do
      expect(@status).to eq 0
      expect(@stdout).not_to match(/Traffic to each uri/)
      expect(@stdout).to match(/Unique visits to each uri/)
    end
  end

  context 'specifying a batch size' do
    let(:arg_string) { "#{Test.fixture('happy_one_user.log')} --batch-size 1" }

    it 'does not print a warning' do
      expect(@status).to eq 0
      expect(@stdout).to match(/Traffic to each uri/)
      expect(@stdout).to match(/Unique visits to each uri/)
    end
  end

  context 'no options' do
    let(:arg_string) { "#{Test.fixture('happy_one_user.log')}" }

    it 'does not print a warning' do
      expect(@status).to eq 0
      expect(@stdout).to match(/Traffic to each uri/)
      expect(@stdout).to match(/Unique visits to each uri/)
    end
  end

  context 'printing help' do
    context 'without a filename' do
      let(:arg_string) { "-h" }

      it 'prints the help' do
        expect(@status).to eq 0
        expect(@stdout).to match(/Usage:/)
      end
    end

    context 'with a filename' do
      let(:arg_string) { "some_file.log -h" }

      it 'prints the help' do
        expect(@status).to eq 0
        expect(@stdout).to match(/Usage:/)
      end
    end

    context 'with no args' do
      let(:arg_string) { '' }

      it 'prints the help and fails' do
        expect(@status).to eq 1
        expect(@stdout).to match(/Usage:/)
      end
    end
  end
end
