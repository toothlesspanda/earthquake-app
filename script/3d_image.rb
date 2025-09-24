#!/usr/bin/env ruby
require_relative "app/services/image_3d_processor"
require 'optparse'

options = { output_image: "output.png" }

OptionParser.new do |opts|
  opts.banner = "Usage: ruby cli_3d.rb [options]"

  opts.on("-i", "--input PATH_OR_URL", "Input image path or URL") { |v| options[:input] = v }
  opts.on("-o", "--output PATH", "Output image path") { |v| options[:output_image] = v }
  opts.on("-t", "--transformation TRANS", "Transformation: grayscale | edges") { |v| options[:transformation] = v }
end.parse!

raise "Input is required" unless options[:input]

processor = ImageGenerator.new(options[:input])
processor.process(transformation: (options[:transformation]&.to_sym || :grayscale))
processor.save_image(options[:output_image])

puts "Processed image saved to #{options[:output_image]}"
