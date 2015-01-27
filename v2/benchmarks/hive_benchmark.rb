require_relative 'benchmark'

class HiveBenchmark < Benchmark
  
  def perform_run(q)
    return nil if not File.exist? self.query_file(q)
    
    out = self.cmd "sudo -u hive hive --database tpch_orc -e \"#{File.read(self.query_file(q))}\""
    
    match = out.match(/OK\nTime taken: (\d+(?:\.\d+){0,1}) seconds$/)
    if match
      return match.captures[0].to_f
    end
    return nil
  end
  
  def after_run(q)
    # TODO Transform output file
  end
end