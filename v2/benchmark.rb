#!/usr/bin/ruby

require 'optparse'
require 'date'
require 'colorize'

options = {
	:benchmarks => [:impala, :hive, :presto],	
	:queries => 1..22,
  :drop_caches_cmd => nil
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
	opts.on("-q", "--queries QUERIES", "Select the queries to run") do |q|
		options[:queries] = q.split(',').map{|q| q.to_i}
	end
	opts.on("-d", "--drop-caches-cmd DROP-CACHES-CMD", "Select the command to drop the FS cache") do |d|
		options[:drop_caches_cmd] = d
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

if !options[:drop_caches_cmd]
  print "Warning: Argument --drop-caches-cmd not given, the FS caches will not be cleared between runs\n"
end

### Run the queries ###

File.open("benchmark.#{DateTime.now().to_time.to_i}.csv", 'w') do |f|
  options[:benchmarks].each do |benchmark|
    print "#{benchmark}\t"
    f.write "#{benchmark},"
    
    # Benchmark the start time of the command line tool,
    # because hive shell for example starts way slower than
    # presto/impala
    `echo ";" > no_query.sql`
    start = Time.now().to_f
    `#{configuration[benchmark][:cmd]} #{configuration[benchmark][:query_file_option]} no_query.sql 2> /dev/null 1> /dev/null`
    startup_time = Time.now().to_f - start
    `rm no_query.sql`
    
    print "@".green
    
    for i in options[:queries] do
  		prepare_file = "#{benchmark}/prepare/q#{i.to_s.rjust(2, '0')}.sql"
  		query_file = "#{benchmark}/queries/q#{i.to_s.rjust(2, '0')}.sql"
  		query = File.read(query_file)
      
      # Some benchmarks require some additional command line flags
  		additional_options = ""
  		if benchmark == :presto
  			additional_options = "--catalog tpch --schema sf1"	
  		end

      # Run the prepare query
  		if File.exists? prepare_file  
  			out = `#{configuration[benchmark][:cmd]} #{configuration[benchmark][:query_file_option]} #{prepare_file} 2>&1 | tee #{f.path.gsub('.csv', '.log')}`
  		end
      
      start = Time.now().to_f
  		out = `#{configuration[benchmark][:cmd]} #{additional_options} #{configuration[benchmark][:query_file_option]} "#{query_file}" 2>&1 | tee #{f.path.gsub('.csv', '.log')}`
      d = Time.now().to_f - start - startup_time
      
      # TODO Run each benchmark multiple times
      
      # Write CSV file
      if $?.to_i == 0 && (out.match(/^(?:"[^"]+"(?:,|\n|$){1})+$/) || out.match(/Fetched \d+ row\(s\) in/) || out.match(/OK\nTime taken: \d+\.\d+ seconds$/))
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
      
      # Finally, clear the FS cache if we know the command
      if options[:drop_caches_cmd]
        `#{options[:drop_caches_cmd]}`
      end
  	end 		
  end
  
  `rm benchmark.csv 2> /dev/null; rm benchmark.log 2> /dev/null`
  `ln -s #{f.path} ./benchmark.csv`
  `ln -s #{f.path.gsub('.csv', '.log')} ./benchmark.log`
end
