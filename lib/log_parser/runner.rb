# frozen_string_literal: true

module LogParser
  module Runner
    module_function

    def call(
      filename:,
      verbose:,
      strict:,
      batch_size:,
      unique_page_views:,
      traffic_counter:
    )
      Logger.verbose = verbose

      model_class = strict ? Models::StrictLogRow : Models::LogRow

      batch_provider = BatchProviders::Csv.new(model_class: model_class, filename: filename, batch_size: batch_size)

      view_builders = []
      view_builders << ViewBuilder::TrafficCounter.new if traffic_counter
      view_builders << ViewBuilder::UniqueViewCounter.new if unique_page_views

      Parser.new(view_builders: view_builders, batch_provider: batch_provider).call
    end
  end
end
