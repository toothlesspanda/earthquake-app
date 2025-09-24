#!/usr/bin/env ruby
require_relative "../config/environment"
require 'optparse'

options = { output_image: "output.png" }

OptionParser.new do |opts|
  opts.banner = "Usage: ruby scripts/3d_image.rb [options]"

  opts.on("-i", "--input PATH_OR_URL", "Input image path or URL") { |v| options[:input] = v }
  opts.on("-t", "--transformation TRANS", "Transformation: grayscale | edges") { |v| options[:transformation] = v }
end.parse!

raise "Input is required" unless options[:input]

processor = ImageTransformer.new(options[:input])
path = processor.process(transformation: (options[:transformation]&.to_sym || :grayscale))

puts "Processed image saved to #{path}"
