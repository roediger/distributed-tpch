class Benchmark
  def initialize(options)
    @options = options
  end
  
  # Returns the lower case name of this benchmark, made up from
  # the class name, e.g.
  # for the class XYZBenchmark 'xyz' is returned.
  def name
    self.class.to_s.gsub('Benchmark', '').downcase
  end

  # Override Point: Whether verify should ignore the first line
  def verify_ignore_first_line
    return true
  end

  # Override Point: Deviation in percent that verify should accept for decimals
  def verify_epsilon
    return 0
  end

  # Override Point: Whether verify should trim strings before comparison
  def verify_trim_strings
    return false
  end
  
  def setup()
    `rm -rf ./log/#{self.name} 2>/dev/null 1>/dev/null`
    `mkdir ./log/#{self.name} 2>/dev/null 1>/dev/null`
  end

  # Override Point: Run any necessary queries, steps, etc.
  # which should be executed before `run`, such as creating
  # intermediary tables.
  # The filesystem cache might me flushed after this method was 
  # called and/or the DB server restarted.
  def prepare(q)
  end
  
  # Execute one run of the benchmark for a specific query q
  def run(q)
    self.before_run q
    t = self.perform_run q
    self.after_run q
    
    return t
  end
  
  def verify()
    if !system("#{@options.verify_dir}/bin/verify log/#{self.name} #{@options.verify_dir}/hyper/tpch/sf#{@options.sf} #{@options.verify_dir}/schema/tpch #{self.verify_ignore_first_line} #{self.verify_epsilon} #{self.verify_trim_strings} 1> /dev/null")
      puts "Incorrect results!".red
    else
      puts "Correct results.".green
    end
  end
  
  # Returns all loaded classes which implement `Benchmark`
  def self.subclasses
    ObjectSpace.each_object(Class).select { |klass| klass < self }
  end
  
  protected
  
  # Override Point: This method is executed before each run
  def before_run(q)
  end
  
  # Override Point: This method is executed and should actually
  # perform a benchmark run for query q.
  # This method should return one or more times, either as scalar
  # or array
  def perform_run(q)
  end
  
  # Override Point: This method is executed after each run
  def after_run(q)
  end
  
  def prepare_file(q)
    "#{self.name}/prepare/q#{q.to_s.rjust(2, '0')}.sql"
  end
  
  def query_file(q)
    "#{self.name}/queries/q#{q.to_s.rjust(2, '0')}.sql"
  end
  
  # Run a bash command
  def cmd(cmd)
    `#{cmd} 2>&1 | tee -a run.log`
  end

  # Run a block n times, and return the times for each run
  # If n == 1, a tuple (return value, time) is returned, an arry of
  # tuples else
  def benchmark(n=1, &block)
    t = []
    for i in 1..n do
      start = Time.now().to_f
      o = block.call
      t << [o, Time.now().to_f - start]
    end
    return n == 1 ? t[0] : t
  end
end

class Array
  def median
    sorted = self.sort
    half_len = (sorted.length / 2.0).ceil
    (sorted[half_len-1] + sorted[-half_len]) / 2.0
  end
end
