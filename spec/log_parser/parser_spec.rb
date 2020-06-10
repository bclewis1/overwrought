# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LogParser::Parser do
  include Test::RowHelper

  def create_batch_provider(batches)
    Class.new do
      define_singleton_method :call do |&blk|
        batches.each do |batch|
          blk.call(batch)
        end
      end
    end
  end

  let(:view_builder_class) do
    Class.new do
      def title
        'Title'
      end

      def results
        @results ||= []
      end

      def process(row)
        self.results << row
      end

      def results_string
        results.each_with_object(String.new) { |res, obj| obj << "#{res.uri} #{res.ip}\n" }
      end
    end
  end

  let(:view_builders) { [view_builder_class.new] }

  subject(:call_parser) do
    described_class.new(view_builders: view_builders, batch_provider: create_batch_provider(batches)).call
  end

  context 'with a single row in one batch' do
    let(:batches) { [[build_row('/a', '1.1.1.1')]] }

    let(:expected_output) do
<<-HEREDOC
Title
/a 1.1.1.1
HEREDOC
  end

    it 'prints the expected output' do
      expect { call_parser }.to output(expected_output).to_stdout
    end
  end

  context 'with multiple rows in one batch' do
    let(:batches) { [[build_row('/a', '1.1.1.1'), build_row('/b', '2.2.2.2')]] }

    let(:expected_output) do
<<-HEREDOC
Title
/a 1.1.1.1
/b 2.2.2.2
HEREDOC
    end

    it 'prints the expected output' do
      expect { call_parser }.to output(expected_output).to_stdout
    end
  end

  context 'with multiple batches' do
    let(:batches) { [[build_row('/a', '1.1.1.1'), build_row('/b', '2.2.2.2')], [build_row('/c', '3.3.3.3')]] }

    let(:expected_output) do
<<-HEREDOC
Title
/a 1.1.1.1
/b 2.2.2.2
/c 3.3.3.3
HEREDOC
    end

    it 'prints the expected output' do
      expect { call_parser }.to output(expected_output).to_stdout
    end
  end

  context 'with multiple view builders' do
    let(:view_builders) { [view_builder_class.new, view_builder_class.new] }
    let(:batches) { [[build_row('/a', '1.1.1.1')]] }

    let(:expected_output) do
<<-HEREDOC
Title
/a 1.1.1.1
Title
/a 1.1.1.1
HEREDOC
    end

    it 'prints the first result twice' do
      expect { call_parser }.to output(expected_output).to_stdout
    end
  end
end
