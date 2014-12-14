#!/usr/bin/ruby

require 'optparse'
require 'date'
require 'colorize'

options = {
	:scale_factor => 1,
	:benchmarks => [:impala, :hive, :presto],	
	:queries => 1..22
}

configuration = {
	:impala => {
		:cmd => ENV['IMPALA_CMD'] || 'impala-shell',
		:query_option => '-q',
		:query_file_option => '-f'
	}, 
	:hive => {
		:cmd => ENV['HIVE_CMD'] || 'hive',
		:query_option => '-e',
		:query_file_option => '-f'
	}, 
	:presto => {
		:cmd => ENV['PRESTO_CMD'] || 'presto',
		:query_option => '--execute',
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


### Run the queries ###

File.open("benchmark.#{DateTime.now().to_time.to_i}.csv", 'w') do |f|
  options[:benchmarks].each do |benchmark|
    print "#{benchmark}\t"
    
    f.write "#{benchmark},"
    
    for i in options[:queries] do
      

  		prepare_file = "#{benchmark}/prepare/q#{i.to_s.rjust(2, '0')}.sql"
  		query_file = "#{benchmark}/queries/q#{i.to_s.rjust(2, '0')}.sql"
  		query = File.read(query_file)

  		if File.exists? prepare_file  
  			`#{configuration[benchmark][:cmd]} #{configuration[benchmark][:query_file_option]} #{prepare_file}`
  		end

  		additional_options = ""
  		if benchmark == :presto
  			additional_options = "--catalog tpch --schema sf#{options[:scale_factor]}"	
  		end
      
      start = Time.now().to_f
  		out = `#{configuration[benchmark][:cmd]} #{additional_options} #{configuration[benchmark][:query_file_option]} "#{query_file}" 2>&1 | tee #{f.path.gsub('.csv', '.log')}`
      d = Time.now().to_f - start
      
      # Write CSV file
      if $?.to_i == 0 && out.match(/^(?:"[^"]+"(?:,|\n|$){1})+$/)
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
  	end 		
  end
  
  `rm benchmark.csv 2> /dev/null; rm benchmark.log 2> /dev/null`
  `ln -s #{f.path} ./benchmark.csv`
  `ln -s #{f.path.gsub('.csv', '.log')} ./benchmark.log`
end



#p options
#p configuration
