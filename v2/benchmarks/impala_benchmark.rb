require_relative 'benchmark'

class ImpalaBenchmark < Benchmark
  def verify_ignore_first_line
    return false
  end

  def verify_epsilon
    return 0.0001
  end

  def verify_trim_strings
    return false
  end

  def perform_run(q)
    return nil if not File.exist? self.query_file(q)
    
    query = File.read(self.query_file(q)) 
    out = self.cmd "impala-shell -d tpch_parquet -B -o log/#{self.name}/#{q}.txt -q \"#{query}\""

    match = out.match(/Fetched \d+ row\(s\) in (\d+(?:\.\d+))s/)
    if match
      return match.captures[0].to_f
    else
      return nil
    end
  end
end
