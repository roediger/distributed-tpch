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
  
  def setup()
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
  # perform a benchmark run for query q
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
    `#{cmd} 2>&1 | tee -a benchmark.log`
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