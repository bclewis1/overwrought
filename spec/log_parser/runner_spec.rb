# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LogParser::Runner do
  subject(:run) do
    described_class.call(
      filename: filename,
      verbose: verbose,
      strict: strict,
      batch_size: batch_size,
      unique_page_views: unique_page_views,
      traffic_counter: traffic_counter
    )
  end

  # some defaults
  let(:verbose) { false }
  let(:strict) { false }
  let(:batch_size) { 1000 }
  let(:unique_page_views) { true }
  let(:traffic_counter) { true }

  describe 'happy, one user fixture' do
    let(:filename) { Test.fixture('happy_one_user.log') }

    context 'with no settings' do
      let(:expected_output) do
        <<-HEREDOC
Traffic to each uri
/a 2 visits
/b 1 visits
/c 1 visits
Unique visits to each uri
/a 1 unique views
/b 1 unique views
/c 1 unique views
        HEREDOC
      end

      it 'produces the expected output' do
        expect { run }.to output(expected_output).to_stdout
      end
    end

    context 'with strict mode on' do
      let(:verbose) { true }
      let(:expected_output) do
        <<-HEREDOC
Traffic to each uri
/a 2 visits
/b 1 visits
/c 1 visits
Unique visits to each uri
/a 1 unique views
/b 1 unique views
/c 1 unique views
        HEREDOC
      end

      it 'does not output any warnings' do
        expect { run }.to output(expected_output).to_stdout
      end
    end
   
    context 'with unique_page_views off' do
      let(:unique_page_views) { false }
      let(:expected_output) do
        <<-HEREDOC
Traffic to each uri
/a 2 visits
/b 1 visits
/c 1 visits
        HEREDOC
      end

      it 'produces the expected output' do
        expect { run }.to output(expected_output).to_stdout
      end
    end

    context 'with traffic_counter off' do
      let(:traffic_counter) { false }
      let(:expected_output) do
        <<-HEREDOC
Unique visits to each uri
/a 1 unique views
/b 1 unique views
/c 1 unique views
        HEREDOC
      end

      it 'produces the expected output' do
        expect { run }.to output(expected_output).to_stdout
      end
    end

    context 'with both traffic counter and unique page views off' do
      let(:unique_page_views) { false }
      let(:traffic_counter) { false }
      let(:expected_output) { '' }

      it 'produces the expected output' do
        expect { run }.to output(expected_output).to_stdout
      end
    end

    context 'with batch size set to 1' do
      let(:batch_size) { 1 }
      let(:expected_output) do
        <<-HEREDOC
Traffic to each uri
/a 2 visits
/b 1 visits
/c 1 visits
Unique visits to each uri
/a 1 unique views
/b 1 unique views
/c 1 unique views
        HEREDOC
      end

      it 'produces the expected output' do
        expect { run }.to output(expected_output).to_stdout
      end
    end
  end

  describe 'invalid ip in log' do
    let(:filename) { Test.fixture('invalid_ip.log') }

    context 'with strict mode off' do
      let(:expected_output) do
        <<-HEREDOC
Traffic to each uri
/a 2 visits
/b 1 visits
/c 1 visits
Unique visits to each uri
/a 2 unique views
/b 1 unique views
/c 1 unique views
        HEREDOC
      end

      it 'allows the invalid ip' do
        expect { run }.to output(expected_output).to_stdout
      end
    end

    context 'with strict mode on' do
      let(:strict) { true }

      let(:expected_output) do
        <<-HEREDOC
Traffic to each uri
/a 1 visits
/b 1 visits
/c 1 visits
Unique visits to each uri
/a 1 unique views
/b 1 unique views
/c 1 unique views
        HEREDOC
      end

      it 'skips the invalid row' do
        expect { run }.to output(expected_output).to_stdout
      end
    end

    context 'with strict mode and verbose mode on' do
      let(:strict) { true }
      let(:verbose) { true }

      let(:expected_output) { /warning/ }
      
      it 'prints a warning when processing the invalid row' do
        expect { run }.to output(expected_output).to_stdout
      end
    end
  end
end
