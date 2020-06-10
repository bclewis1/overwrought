module LogParser
  class Parser
    def initialize(view_builders:, batch_provider:)
      @view_builders = view_builders
      @batch_provider = batch_provider
    end

    def call
      batch_provider.call do |batch|
        batch.each do |row|
          view_builders.each do |view_builder|
            view_builder.process(row)
          end
        end
      end
      print_results
    end

    private

    def print_results
      view_builders.each do |view_builder|
        puts view_builder.title
        puts view_builder.results_string
      end
    end

    attr_reader :view_builders, :batch_provider
  end
end
