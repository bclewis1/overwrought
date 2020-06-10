# frozen_string_literal: true

require 'dry-struct'

module LogParser
  module Models
    class StrictLogRow < Dry::Struct::Value
      # only matching IPv4, taken from https://stackoverflow.com/questions/5284147/validating-ipv4-addresses-with-regexp
      IP_REGEX = /^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/

      transform_keys(&:to_sym)

      attribute :ip, Types::String.constrained(format: IP_REGEX)
      attribute :uri, Types::String

      def self.create(args)
        new(args)
      rescue Dry::Struct::Error => e
        LogParser::Logger.print "warning: #{e.message}"
        raise InvalidLogRow, e.message
      end
    end
  end
end
