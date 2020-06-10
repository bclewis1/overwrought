# frozen_string_literal: true

require 'csv'

module LogParser
  module Models
    class LogRow
      def initialize(uri:, ip:)
        @uri = uri
        @ip = ip
      end

      def self.create(args)
        new(args)
      rescue ArgumentError => e
        LogParser::Logger.print "warning: #{e.message}"
        raise InvalidLogRow, e.message
      end

      attr_reader :uri, :ip
    end
  end
end
