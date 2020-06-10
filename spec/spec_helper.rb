require 'test'
require 'row_helper'

require 'log_parser'

require 'simplecov'
SimpleCov.start if ENV['COVERAGE'] == 'true'

RSpec.configure do |c|
  c.define_derived_metadata do |meta|
    meta[:aggregate_failures] = true
  end
end
