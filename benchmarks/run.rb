#!/usr/bin/ruby
require 'optparse'
require 'date'
require 'colorize'
require 'ostruct'

require_relative 'hive_benchmark'
require_relative 'impala_benchmark'
require_relative 'memsql_benchmark'
require_relative 'vector_benchmark'

########################
# Parse all parameters #
########################
options = OpenStruct.new
options.benchmarks = Benchmark.subclasses
options.queries = 1..22
options.n = 1
options.sf = 100
options.verify = true
options.profile = false
options.drop_caches = false
options.restart = false
options.drop_caches_cmd = "for i in `seq 11 16`; do ssh scyper$i \"/usr/local/bin/flush_fs_caches\"; done"
options.verify_dir = "~/repositories/verify"
options.statistics_cmd = "for i in `seq 11 16`; do ssh scyper$i \"awk '{print \\$3, \\$7}' /sys/class/block/sda/stat /sys/class/block/sdb/stat /sys/class/block/sdc/stat | cat - /sys/class/infiniband/mlx4_0/ports/1/counters/port_rcv_packets /sys/class/infiniband/mlx4_0/ports/1/counters/port_xmit_packets /sys/class/infiniband/mlx4_0/ports/1/counters/port_rcv_data /sys/class/infiniband/mlx4_0/ports/1/counters/port_xmit_data | xargs\"; done"

OptionParser.new do |opts|
  opts.banner = "Usage: #{$0} [options]"

  opts.on("-b", "--benchmarks hive,impala,memsql,vector", Array, "Which benchmarks to run (default " + options.benchmarks.to_s + ")") do |b|
    options.benchmarks = b.map{|b| Object.const_get(b.capitalize+"Benchmark")}
  end
  opts.on("-q", "--queries QUERIES", "Which queries to run (default " + options.queries.to_s + ")") do |q|
    options.queries = q.split(',').map{|q| q.to_i}
  end
  opts.on("-n", "--runs NUMBER-OF-RUNS", "The number of runs (default " + options.n.to_s + ")") do |n|
    options.n = n.to_i
  end
  opts.on("-s", "--scale-factor SCALE-FACTOR", "The TPC-H scale factor (default " + options.sf.to_s + ")") do |sf|
    options.sf = sf.to_i
  end
  opts.on("-v", "--verify VERIFY-RESULTS", [:true, :false], "Whether the query results should be verified (default " + options.verify.to_s + ")") do |v|
    options.verify = (v == :true)
  end
  opts.on("-p", "--profile PROFILE-IO", [:true, :false], "Whether the disk and network I/O should be profiled (default " + options.profile.to_s + ")") do |p|
    options.profile = (p == :true)
  end
  opts.on("-d", "--drop-caches DROP-CACHES", [:true, :false], "Whether FS caches should be dropped between runs (default " + options.drop_caches.to_s + ")") do |d|
    options.drop_caches = (d == :true)
  end
  opts.on("-r", "--restart RESTART", [:true, :false], "Whether the system should be restarted between runs (default " + options.restart.to_s + ")") do |r|
    options.restart = (r == :true)
  end

  opts.on_tail("-h", "--help", "Show this message") do
    puts opts
    exit
  end
end.parse!(ARGV)

def gather_statistics cmd
    # split statistics by host
    statistics = []
    `#{cmd} 2>&1 | tee -a run.log`.split("\n").each do |statistics_host|
puts statistics_host.gsub(/ /, "\t")
      statistics << statistics_host.split(' ').map(&:to_i)
    end

    # sum statistics of hosts
    statistics.inject do |result, element|
      element.each_with_index do |value, index|
        result[index] += value
      end
      result
    end
end

def geomean(array)
  array.inject(1.0, :*) ** (1.0 / array.size)
end

puts "$configuration:"
puts "\tBenchmarks:\t"+options.benchmarks.join(', ')
puts "\t#Queries:\t"+options.queries.count.to_s
puts "\tRuns:\t\t"+options.n.to_s
puts "\tVerify results:\t"+options.verify.to_s
puts "\tProfile I/O:\t"+options.profile.to_s
puts "\tRestart:\t"+options.restart.to_s
puts "\tDrop caches:\t"+options.drop_caches.to_s

######################
# Run the benchmarks #
######################
`rm -f run.csv;`
`rm -f run.log;`
`mkdir -p log`

File.open("run.csv", 'w') do |f|
  f.sync = true

  options.benchmarks.each do |benchmark_clazz|
    benchmark = benchmark_clazz.new options
    benchmark.setup
    print "#{benchmark.name}\n"
    f.write "#{benchmark.name}\n"

    # gather statistics
    statistics_before = []
    if (options.profile)
      puts "gathering I/O stats..."
      statistics_before = gather_statistics options.statistics_cmd
    end

    # Run each query
    runtimes = []
    for q in options[:queries] do

      # Write current run to console and file
      print "Q#{q}\t"

      # Run each query N times
      query_runtimes = []
      for n in 1..options[:n] do
        `echo "Running Benchmark #{benchmark.name}, Query #{q}, Run #{n}" >> run.log`

        benchmark.prepare q

        # Clear the FS cache if the command was given
        # and restart the server if possible
        if options.drop_caches
          `#{options.drop_caches_cmd} 2>&1 | tee -a run.log`
        end

        t = benchmark.run q

        # Write the result to the file and a green or red dot to
        # the console
        if t
          print ".".green
          query_runtimes << t
          t = t.is_a?(Array) ? t : [t]
          f.write(t.join("\t"))
        else
          print ".".red
        end

        if n != options[:n]
          f.write "\t"
        else
          f.write "\n"
          print "\n"
        end
      end
      if !query_runtimes.empty?
        runtimes << query_runtimes.median
      end
    end

    runtime = runtimes.reduce(:+)
    puts "time\t#{runtime.round(2)}"
    puts "geomean\t#{geomean(runtimes).round(2)}"
    puts "QpH\t#{(options[:queries].size*60.0*60.0/runtime).round(2)}"

    # verify results
    benchmark.verify

    # gather statistics
    if options.profile
      puts "gathering I/O stats..."
      statistics = []
      (gather_statistics options.statistics_cmd).each_with_index do |value, index|
        statistics[index] = value - statistics_before[index]
      end
      puts "disk read\t#{((statistics[0]+statistics[2]+statistics[4]).to_f/1000/1000).round(2)} GB"
      puts "disk write\t#{((statistics[1]+statistics[3]+statistics[5].to_f)/1000/1000).round(2)} GB"
      puts "packets recv\t#{(statistics[6].to_f/1000/1000).round(2)} million"
      puts "packets sent\t#{(statistics[7].to_f/1000/1000).round(2)} million"
      puts "data recv\t#{(statistics[8]*4.0/1000/1000/1000).round(2)} GB"
      puts "data sent\t#{(statistics[9]*4.0/1000/1000/1000).round(2)} GB"
    end
  end
end
