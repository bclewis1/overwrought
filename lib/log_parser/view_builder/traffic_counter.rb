# frozen_string_literal: true

module LogParser
  module ViewBuilder
    class TrafficCounter
      def initialize
        @visits = Hash.new(0)
      end

      def title
        "Traffic to each uri"
      end

      def process(row)
        visits[row.uri] = visits[row.uri] + 1
      end

      def results_string
        results.each_with_object(String.new) do |(uri, visits), str|
          str << "#{uri} #{visits} visits\n"
        end
      end

      def results
        visits.sort_by { |k, v| -v }
      end

      private

      attr_reader :visits
    end
  end
end

