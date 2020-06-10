# frozen_string_literal: true

require 'csv'

module LogParser
  module BatchProviders
    class Csv
      def initialize(model_class:, filename:, batch_size: 1000)
        @model_class = model_class
        @filename = filename
        @batch_size = batch_size
      end

      def call
        batch = []
        ::CSV.foreach(filename, col_sep: ' ', headers: [:uri, :ip]) do |row|
          begin
            batch << model_class.create(row.to_h)
          rescue LogParser::Models::InvalidLogRow
            next
          end
          if batch.length == batch_size
            yield batch
            batch = []
          end
        end
        yield(batch) if batch.length > 0

      end

      private

      attr_reader :model_class, :filename, :batch_size
    end
  end
end
