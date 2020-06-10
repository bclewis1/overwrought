# frozen_string_literal: true

module LogParser
  module ViewBuilder
    class UniqueViewCounter
      def initialize
        @visits = {}
      end

      def title
        "Unique visits to each uri"
      end

      def process(row)
        visits[row.uri] ||= Set.new
        visits[row.uri].add(row.ip)
      end

      def results_string
        results.each_with_object(String.new) do |(uri, unique_visits), str|
          str << "#{uri} #{unique_visits} unique views\n"
        end
      end

      def results
        unique_views = visits.map do |uri, visitor_set|
          [uri, visitor_set.length]
        end
        unique_views.sort_by { |k, v| -v }
      end

      private

      attr_reader :visits
    end
  end
end
