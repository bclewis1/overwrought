# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LogParser::ViewBuilder::UniqueViewCounter do
  include Test::RowHelper

  describe '#title' do
    subject { described_class.new.title }

    it { is_expected.to be_a String }
  end

  describe '#results' do
    let(:builder) { described_class.new }

    context 'with nothing in it' do
      it do
        expect(builder.results).to eq []
      end
    end

    context 'when running twice for identical visits' do
      let(:builder) { described_class.new }
      let(:row) { build_row('/a', '1.1.1.1') }

      before do
        builder.process(row)
        builder.process(row)
      end

      it 'results in just one visit' do
        results = builder.results
        expect(results).to eq [['/a', 1]]
      end
    end

    context 'when running twice for different uris, same ip' do
      let(:builder) { described_class.new }

      before do
        builder.process(build_row('/a', '1.1.1.1'))
        builder.process(build_row('/b', '1.1.1.1'))
      end

      it 'results in multiple uri rows' do
        results = builder.results
        expect(results.sort).to eq [['/a', 1], ['/b', 1]].sort
      end
    end

    context 'with a single unique visit and two unique visits' do
      let(:builder) { described_class.new }

      before do
        builder.process(build_row('/a', '1.1.1.1'))
        builder.process(build_row('/b', '1.1.1.1'))
        builder.process(build_row('/b', '1.1.1.2'))
      end

      it 'results in multiple uri rows' do
        results = builder.results
        expect(results).to eq [['/b', 2], ['/a', 1]]
      end
    end
  end

  describe 'print_results' do
    let(:builder) { described_class.new }

    context 'with nothing in it' do
      it do
        expect(builder.results_string).to eq ""
      end
    end

    context 'with a single unique visit and two unique visits' do
      let(:builder) { described_class.new }

      before do
        builder.process(build_row('/a', '1.1.1.1'))
        builder.process(build_row('/b', '1.1.1.1'))
        builder.process(build_row('/b', '1.1.1.2'))
      end

      it 'results in multiple uri rows' do
        expect(builder.results_string).to eq(
<<-HEREDOC
/b 2 unique views
/a 1 unique views
HEREDOC
        )
      end
    end
  end
end
