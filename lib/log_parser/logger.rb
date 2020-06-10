# frozen_string_literal: true

module LogParser
  module Logger
    class << self
      attr_accessor :verbose

      def print(message)
        puts message if verbose
      end
    end
  end
end
