#!/usr/bin/ruby

require 'optparse'

options = {
	:scale_factor => 1,
	:benchmarks => [:impala, :hive, :presto]	
}

configuration = {
	:impala => {
		:cmd => ENV['IMPALA_CMD'] || 'impala-shell',
		:query_file_option => '-f'
	}, 
	:hive => {
		:cmd => ENV['HIVE_CMD'] || 'hive',
		:query_file_option => '-f'
	}, 
	:presto => {
		:cmd => ENV['PRESTO_CMD'] || 'presto',
		:query_file_option => '-f'
	}
}

OptionParser.new do |opts|
	opts.banner = "Usage: example.rb [options]"

	opts.on("-b", "--benchmarks BENCHMARKS", "Select Benchmarks to run") do |b|
  		options[:benchmarks] = b.split(',').map{|b| b.to_sym}
  	end
	opts.on("-f", "--scale-factor SCALE-FACTOR", "Select the scale factor of the TPC-H data set") do |sf|
		options[:scale_factor] = Integer(sf)
	end

	opts.on("-p", "--presto-cmd PRESTO-CMD", "Select the command to run presto") do |cmd|
		configuration[:presto][:cmd] = cmd
	end
	opts.on("-p", "--hive-cmd PRESTO-CMD", "Select the command to run hive") do |cmd|
        configuration[:hive][:cmd] = cmd
    end
	opts.on("-p", "--impala-cmd PRESTO-CMD", "Select the command to run impala") do |cmd|
        configuration[:impala][:cmd] = cmd
    end
end.parse!

for i in 1..22 do
	print "Running query #{i}\n"
	options[:benchmarks].each do |benchmark|
		print " -> #{benchmark}\n" 
		`#{configuration[benchmark][:cmd]} #{configuration[benchmark][:query_file_option]} #{benchmark}/prepare/#{i.to_s.rjust(2, '0')}`	
	end 		
end

p options
p configuration
