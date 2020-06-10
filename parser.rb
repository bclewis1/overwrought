#!/usr/bin/env bundle exec ruby

$LOAD_PATH.unshift(File.join(__dir__, 'lib'))

require 'log_parser'
require 'optparse'

options = {
  verbose: false,
  strict: false,
  batch_size: 1000,
  unique_page_views: true,
  traffic_counter: true
}

opts = OptionParser.new do |opts|
  opts.banner = 'Usage: parser.rb FILENAME [options]'

  opts.on('-v', '--[no-]verbose', 'Run verbosely (default false)') do |v|
    options[:verbose] = v
  end

  opts.on('-s', '--[no-]strict', 'Strict mode (drops non-ipv4 traffic) (default false)') do |s|
    options[:strict] = s
  end

  opts.on('-b', '--batch-size BATCHSIZE', Integer, 'Number of rows to process at once (default 1000)') do |b|
    options[:batch_size] = b
  end

  opts.on('--views a,b', Array, 'Views to display. (unique-page-views, traffic-counter available. Defaults to both.)') do |views|
    options[:unique_page_views] = views.include?('unique-page-views')
    options[:traffic_counter] = views.include?('traffic-counter')
  end

  opts.on("-h", "--help", "Prints this help") do
    puts opts
    exit
  end
end

opts.parse!

if ARGV.length == 0
  puts opts
  exit 1
end

options[:filename] = ARGV.last


LogParser::Runner.call(options)
