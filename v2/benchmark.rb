#!/usr/bin/ruby

require 'optparse'

options = {}
OptionParser.new do |opts|
	opts.banner = "Usage: example.rb [options]"

	opts.on("-b", "--benchmarks BENCHMARKS", "Select Benchmarks to run") do |b|
  		options[:benchmarks] = b
  	end
	opts.on("-f", "--scale-factor SCALE-FACTOR", "Select the scale factor of the TPC-H data set") do |sf|
		options[:scale_factor] = sf
	end
end.parse!

p options
