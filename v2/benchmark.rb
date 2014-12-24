#!/usr/bin/ruby

require 'optparse'
require 'date'
require 'colorize'

options = {
	:benchmarks => [:impala, :hive, :vector],	
	:queries => 1..22,
  :drop_caches_cmd => nil,
  :n => 1,
  :restart => true
}

configuration = {
  :impala => {
		:cmd => ENV['IMPALA_CMD'] || 'impala-shell',
		:query_file_option => '-f',
    :success_regexp => /Fetched \d+ row\(s\) in/
	}, 
	:hive => {
		:cmd => ENV['HIVE_CMD'] || 'hive',
		:query_file_option => '-f',
    :success_regexp => /OK\nTime taken: \d+\.\d+ seconds$/
	}, 
	:vector => {
		:cmd => ENV['VECTOR_CMD'] || nil,
    :cmd_end_token => '"',
    :restart_cmd => ENV['VECTOR_RESTART_CMD'] || nil,
		:query_file_option => '<',
    :success_regexp => /Your SQL statement\(s\) have been committed/
	}
}

OptionParser.new do |opts|
	opts.banner = "Usage: example.rb [options]"

	opts.on("-b", "--benchmarks BENCHMARKS", "Select Benchmarks to run") do |b|
  		options[:benchmarks] = b.split(',').map{|b| b.to_sym}
  	end
	opts.on("-q", "--queries QUERIES", "Select the queries to run") do |q|
		options[:queries] = q.split(',').map{|q| q.to_i}
	end
	opts.on("-d", "--drop-caches-cmd DROP-CACHES-CMD", "Select the command to drop the FS cache") do |d|
		options[:drop_caches_cmd] = d
	end
	opts.on("-n", "--number NUMBER-OF-RUNS", "Specify the number of runs") do |n|
		options[:n] = n.to_i
	end
	opts.on("-r", "--restart-server RESTART-SERVER", "Specify whether the database server should be restarted between runs") do |r|
		options[:restart] = !(r.match(/(no|false)/))
	end

	opts.on("-h", "--hive-cmd HIVE-CMD", "Select the command to run hive") do |cmd|
    configuration[:hive][:cmd] = cmd
  end
	opts.on("-i", "--impala-cmd IMPALA-CMD", "Select the command to run impala") do |cmd|
    configuration[:impala][:cmd] = cmd
  end
	opts.on("-v", "--vector-cmd VECTOR-CMD", "Select the command to run vector") do |cmd|
    configuration[:vector][:cmd] = cmd
  end
	opts.on("-y", "--vector-restart-cmd VECTOR-CMD", "Select the command to restart vector") do |cmd|
    configuration[:vector][:restart_cmd] = cmd
  end
end.parse!

if !options[:drop_caches_cmd]
  print "Warning: Argument --drop-caches-cmd not given, the FS caches will not be cleared between runs\n"
end

# Check the options/configuration
if configuration[:vector][:cmd] == nil
  puts "Vector command not given"
  exit 1
end
if configuration[:vector][:restart_cmd] == nil && options[:restart]
  puts "Vector Restart command not given"
  exit 1
end

### Run the queries ###

File.open("benchmark.#{DateTime.now().to_time.to_i}.csv", 'w') do |f|
  f.sync = true
  
  # set symlinks benchmark.csv and benchmark.log to the currently
  # active files
  `rm benchmark.csv 2> /dev/null; rm benchmark.log 2> /dev/null`
  `ln -s #{f.path} ./benchmark.csv`
  `ln -s #{f.path.gsub('.csv', '.log')} ./benchmark.log`
  
  options[:benchmarks].each do |benchmark|
    end_token = configuration[benchmark][:cmd_end_token] || ''
    
    # Benchmark the start time of the command line tool,
    # because hive shell for example starts way slower than
    # impala
    `echo ";#{(benchmark == :vector ? '\g' : '')}" > no_query.sql`
    start = Time.now().to_f
    `#{configuration[benchmark][:cmd]} #{configuration[benchmark][:query_file_option]} no_query.sql#{end_token} 2> /dev/null 1> /dev/null`
    startup_time = Time.now().to_f - start
    `rm no_query.sql`
    
    # Run each benchmark N times
    for n in 1..options[:n] do 
      
      # Write current run to console and CSV file
      n_str = options[:n] > 1 ? " (#{n})" : ""
      print "#{benchmark}#{n_str}\t"
      f.write "#{benchmark}#{n_str},"
  
      for i in options[:queries] do
    		prepare_file = "#{benchmark}/prepare/q#{i.to_s.rjust(2, '0')}.sql"
    		query_file = "#{benchmark}/queries/q#{i.to_s.rjust(2, '0')}.sql"
        
        # Run the prepare query
    		if File.exists? prepare_file  
    			out = `#{configuration[benchmark][:cmd]} #{configuration[benchmark][:query_file_option]} #{prepare_file} 2>&1 | tee -a #{f.path.gsub('.csv', '.log')}`
    		end
        
        # Clear the FS cache if the command was given
        # and restart the server if possible
        if options[:drop_caches_cmd]
          `#{options[:drop_caches_cmd]} 2>&1 | tee -a #{f.path.gsub('.csv', '.log')}`
        end
        
        # Restart the server
        if benchmark == :vector && options[:restart]
          `#{configuration[benchmark][:restart_cmd]}`
        end
    
        # Run the actual TPC-H query, taking start
        # and end time
        start = Time.now().to_f
    		out = `#{configuration[benchmark][:cmd]} #{configuration[benchmark][:query_file_option]} '#{query_file}'#{end_token} 2>&1 | tee -a #{f.path.gsub('.csv', '.log')}` 
        d = Time.now().to_f - start - startup_time
    
        # Check if the output matches with expected success output patterns
        # and write result to CSV file
        if $?.to_i == 0 && configuration.collect{|k, v| v[:success_regexp]}.map{|r| out.match(r)}.any?
          print ".".green
          f.write "#{d}"
        else
          print ".".red
        end
    
        if i != options[:queries].last
          f.write ','
        else
          f.write "\n"
          print "\n"
        end
    
        f.flush()
  	  end 	
    end	
  end
end
