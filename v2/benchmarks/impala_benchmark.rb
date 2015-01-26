require_relative 'benchmark'

class ImpalaBenchmark < Benchmark
  
  def perform_run(q)
    return nil if not File.exist? self.query_file(q)
    
    query = File.read(self.query_file(q)) 
    out = self.cmd "impala-shell -d tpch_parquet -B -o log/impala/#{q}.txt -q \"#{query}\""
    
    match = out.match(/Fetched \d+ row\(s\) in (\d+(?:\.\d+))s/)
    if match
      return match.captures[0].to_f
    else
      return nil
    end
  end
end