# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LogParser::Models::StrictLogRow do
  describe 'uri not included' do
    it do
      expect { described_class.create(ip: '100.100.100.100') }.to raise_error(LogParser::Models::InvalidLogRow)
    end
  end

  describe 'ip not included' do
    it do
      expect { described_class.create(uri: '/a') }.to raise_error(LogParser::Models::InvalidLogRow)
    end
  end

  describe 'creating a log row with all parameters' do
    subject(:log_row) { described_class.create(ip: ip, uri: uri) }

    context 'with valid ip and uri' do
      let(:ip) { '100.100.100.100' }
      let(:uri) { '/a' }

      it do
        expect(log_row.ip).to eq ip
        expect(log_row.uri).to eq uri
      end
    end

    context 'ip address invalid' do
      let(:ip) { '100.100.100.100.100' }
      let(:uri) { '/a' }

      it do
        expect { log_row }.to raise_error(LogParser::Models::InvalidLogRow)
      end
    end

    context 'uri not a string' do
      let(:ip) { '100.100.100.100' }
      let(:uri) { 1 }

      it do
        expect { log_row }.to raise_error(LogParser::Models::InvalidLogRow)
      end
    end
  end
end
