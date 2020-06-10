require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.setup

module LogParser
  module_function

  def parse_log
    Worker.new(

    ).call
  end
end
