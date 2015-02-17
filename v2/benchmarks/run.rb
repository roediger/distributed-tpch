#!/usr/bin/ruby

require 'optparse'
require 'date'
require 'colorize'
require 'ostruct'

require_relative 'impala_benchmark'
require_relative 'vector_benchmark'
require_relative 'hive_benchmark'

########################
# Parse all parameters #
########################
options = OpenStruct.new
options.benchmarks = Benchmark.subclasses
options.queries = 1..22
options.n = 1
options.drop_caches = true
options.restart = true
options.drop_caches_cmd = 'for i in `seq 11 16`;do ssh scyper$i "/usr/local/bin/flush_fs_caches"; done'

OptionParser.new do |opts|
	opts.banner = "Usage: #{$0} [options]"

	opts.on("-b", "--benchmarks impala,hive,vector", Array, "Select the benchmarks to run") do |b|
  		options.benchmarks = b.map{|b| Object.const_get(b.capitalize+"Benchmark")}
  	end
	opts.on("-q", "--queries QUERIES", "Select the queries to run") do |q|
		options.queries = q.split(',').map{|q| q.to_i}
	end
	opts.on("-d", "--drop-caches [DROP-CACHES]", [:true, :false], "Select if FS caches should be dropped") do |d|
		options.drop_caches = (d == :true)
	end
	opts.on("-n", "--runs NUMBER-OF-RUNS", "Specify the number of runs") do |n|
		options.n = n.to_i
	end
	opts.on("-r", "--restart-server [RESTART-SERVER]", [:true, :false], "Specify whether the database server should be restarted between runs") do |r|
		options.restart = (r == :true)
	end
  
  opts.on_tail("-h", "--help", "Show this message") do
    puts opts
    exit
  end
end.parse!(ARGV)

puts "$configuration:"
puts "\tBenchmarks: \t"+options.benchmarks.join(', ')
puts "\t#Queries: \t"+options.queries.count.to_s
puts "\tRuns: \t\t"+options.n.to_s
puts "\tRestart DB: \t"+options.restart.to_s
puts "\tDrop Caches: \t"+options.drop_caches.to_s

######################
# Run the benchmarks #
######################
`rm -f benchmark.csv;` 
`rm -f benchmark.log;` 
`mkdir -p log`

File.open("benchmark.csv", 'w') do |f|
  f.sync = true
    
  options.benchmarks.each do |benchmark_clazz|
    benchmark = benchmark_clazz.new options
    benchmark.setup
    
    # Run each benchmark N times
    for n in 1..options[:n] do 
      
      # Write current run to console and file
      n_str = options[:n] > 1 ? " (#{n})" : ""
      print "#{benchmark.name}#{n_str}\t"
      f.write "#{benchmark.name}#{n_str},"
      
      # Run each query
      for q in options[:queries] do
        `echo "Running Benchmark #{benchmark.name}, Query #{q}, Run #{n}" >> benchmark.log`
        
        benchmark.prepare q
        
        # Clear the FS cache if the command was given
        # and restart the server if possible
        if options.drop_caches
          `#{options.drop_caches_cmd} 2>&1 | tee -a benchmark.log`
        end
        
        t = benchmark.run q
        t = t.is_a?(Array) ? t : [t]
        
        # Write the result to the file and a green or red dot to
        # the console
        if t
          print ".".green
          f.write "#{t.join(',')}"
        else
          print ".".red
        end
    
        if q != options.queries.last
          f.write ','
        else
          f.write "\n"
          print "\n"
        end
      end
    end
  end
end

