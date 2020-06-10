# frozen_string_literal: true

require 'spec_helper'
require 'ostruct'

RSpec.describe LogParser::BatchProviders::Csv do
  describe 'reading from a valid csv' do
    subject(:processor) { described_class.new(model_class: model_class, filename: filename, batch_size: batch_size) }

    let(:model_class) do
      Struct.new(:uri, :ip) do
        def self.create(uri:, ip:)
          new(uri, ip)
        end
      end
    end
    let(:filename) { Test.fixture('happy_one_user.log') }

    context 'with batch size 1' do
      let(:batch_size) { 1 }

      it do
        expect { |blk| processor.call(&blk) }.to yield_control.exactly(4).times
        expect { |blk| processor.call(&blk) }.to yield_successive_args(
          [model_class.new('/a', '100.100.100.100')],
          [model_class.new('/a', '100.100.100.100')],
          [model_class.new('/b', '100.100.100.100')],
          [model_class.new('/c', '100.100.100.100')],
        )
      end
    end

    context 'with batch size 2' do
      let(:batch_size) { 2 }

      it do
        expect { |blk| processor.call(&blk) }.to yield_control.exactly(2).times
        expect { |blk| processor.call(&blk) }.to yield_successive_args(
          [
            model_class.new('/a', '100.100.100.100'),
            model_class.new('/a', '100.100.100.100')
          ],
          [
            model_class.new('/b', '100.100.100.100'),
            model_class.new('/c', '100.100.100.100')
          ]
        )
      end

      context 'with batch size 3' do
        let(:batch_size) { 3 }

        it do
          expect { |blk| processor.call(&blk) }.to yield_control.exactly(2).times
          expect { |blk| processor.call(&blk) }.to yield_successive_args(
            [
              model_class.new('/a', '100.100.100.100'),
              model_class.new('/a', '100.100.100.100'),
              model_class.new('/b', '100.100.100.100')
            ],
            [
              model_class.new('/c', '100.100.100.100')
            ]
          )
        end
      end
    end
  end
end
