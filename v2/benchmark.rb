#!/usr/bin/ruby

require 'optparse'
require 'date'
require 'colorize'
require 'ostruct'

options = OpenStruct.new
options.benchmarks = [:impala, :hive, :vector]
options.queries = 1..22
options.n = 1
options.drop_caches = true
options.restart = true
options.drop_caches_cmd = 'for i in `seq 11 16`;do ssh scyper$i "/usr/local/bin/flush_fs_caches"; done'

$configuration = {
  :impala => {
		:cmd => ENV['IMPALA_CMD'] || 'impala-shell --database=tpch_parquet $ARGS',
    :query_option => '-q',
		:query_file_option => '-f',
    :success_regexp => /Fetched \d+ row\(s\) in/
	}, 
	:hive => {
		:cmd => ENV['HIVE_CMD'] || 'sudo -u hive hive $ARGS',
    :query_option => '-e',
		:query_file_option => '-f',
    :success_regexp => /OK\nTime taken: \d+\.\d+ seconds$/
	}, 
	:vector => {
		:cmd => ENV['VECTOR_CMD'] || 'sudo -u actian bash -c "source ~actian/.ingAHsh; /opt/Actian/AnalyticsPlatformAH/ingres/bin/sql dbtest $ARGS"',
    :restart_cmd => ENV['VECTOR_RESTART_CMD'] || 'sudo -u actian bash -c "source ~actian/.ingAHsh; /opt/Actian/AnalyticsPlatformAH/ingres/utility/ingstop -f; /opt/Actian/AnalyticsPlatformAH/ingres/utility/ingstart"',
		:query_file_option => '<',
    :success_regexp => /Your SQL statement\(s\) have been committed/
	}
}

OptionParser.new do |opts|
	opts.banner = "Usage: #{$0} [options]"

	opts.on("-b", "--benchmarks impala,hive,vector", Array, "Select the benchmarks to run") do |b|
  		options.benchmarks = b.map{|b| b.to_sym}
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


### Run the queries ###

def cmd(benchmark, args)
  $configuration[benchmark][:cmd].gsub('$ARGS', args)+" 2>&1 | tee -a benchmark.log"
end

def benchmark(n=1, &block)
  t = []
  for i in 1..n do
    start = Time.now().to_f
    block.call
    t << Time.now().to_f - start
  end
  return n == 1 ? t[0] : t
end

class Array
  def median
    sorted = self.sort
    half_len = (sorted.length / 2.0).ceil
    (sorted[half_len-1] + sorted[-half_len]) / 2.0
  end
end

`rm -f benchmark.csv; rm -f benchmark.log; rm -rf ./log; mkdir log`
File.open("benchmark.csv", 'w') do |f|
  f.sync = true
    
  options.benchmarks.each do |benchmark|
    
    # Benchmark the start time of the command line tool,
    # because hive shell for example starts way slower than
    # impala
    if benchmark == :vector
      File.open('no_query.sql', 'w') {|f| f.write(';\g') }
      
      startup_time = (benchmark 3 do 
        `#{cmd(benchmark, "#{$configuration[benchmark][:query_file_option]} no_query.sql")}`
      end).median
      
      `rm no_query.sql`
    else
      startup_time = (benchmark 3 do 
        `#{cmd(benchmark, "#{$configuration[benchmark][:query_option]} \";\"")}`
      end).median
    end
    
    # Run each benchmark N times
    for n in 1..options[:n] do 
      
      # Write current run to console and CSV file
      n_str = options[:n] > 1 ? " (#{n})" : ""
      print "#{benchmark}#{n_str}\t"
      f.write "#{benchmark}#{n_str},"
      
      # Write measured startup time
      f.write "#{startup_time},"
  
      for i in options[:queries] do
    		prepare_file = "#{benchmark}/prepare/q#{i.to_s.rjust(2, '0')}.sql"
    		query_file = "#{benchmark}/queries/q#{i.to_s.rjust(2, '0')}.sql"
        
        `echo "Running Benchmark #{benchmark}, Query #{i}, Run #{n}" >> benchmark.log`
        
        # Run the prepare query
    		if File.exists? prepare_file  
          `#{cmd(benchmark, "#{$configuration[benchmark][:query_file_option]} #{prepare_file}")}`
    		end
        
        # Clear the FS cache if the command was given
        # and restart the server if possible
        if options.drop_caches
          `#{options.drop_caches_cmd} 2>&1 | tee -a benchmark.log`
        end
        
        # Restart the server
        if options.restart
          if $configuration[benchmark][:restart_cmd]
            `#{$configuration[benchmark][:restart_cmd]} 2>&1 | tee -a benchmark.log`
          end
        end
    
        # Run the actual TPC-H query, taking start
        # and end time
        start = Time.now().to_f
        out = nil
        log_cmd = " tee log/#{benchmark}-#{i}-#{n}.out"
        if $configuration[benchmark][:query_option]
          out = `#{cmd(benchmark, "#{$configuration[benchmark][:query_option]} \"#{File.read(query_file)}\"")} #{log_cmd}` if File.exist? query_file
        else
          out = `#{cmd(benchmark, "#{$configuration[benchmark][:query_file_option]} #{query_file}")} #{log_cmd}`
        end
        
        d = out.nil? ? 0 : Time.now().to_f - start - startup_time
    
        # Check if the output matches with expected success output patterns
        # and write result to CSV file
        if $?.to_i == 0 && !out.nil? && out.match($configuration[benchmark][:success_regexp])
          print ".".green
          f.write "#{d}"
        else
          print ".".red
        end
    
        if i != options.queries.last
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
