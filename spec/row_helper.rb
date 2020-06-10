# frozen_string_literal: true

require 'ostruct'

module Test
  module RowHelper
    def build_row(uri, ip)
      OpenStruct.new(uri: uri, ip: ip)
    end
  end
end
