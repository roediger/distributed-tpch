require_relative 'benchmark'

class VectorBenchmark < Benchmark
  
  def setup()
    super
    
    `chmod -R 777 log/vector 1>/dev/null 2>/dev/null`
    
    File.open('no_query.sql', 'w') {|f| f.write(';\g') }
    
    @startup_time = (self.benchmark 3 do 
      self.cmd "sudo -u actian bash -c \"source ~actian/.ingAHsh; /opt/Actian/AnalyticsPlatformAH/ingres/bin/sql dbtest < no_query.sql\""
    end).map{|o,t| t}.median
    
    `rm no_query.sql`
  end
  
  def perform_run(q)
    return nil if not File.exist? self.query_file(q)
    
    t = (self.benchmark 1 do
      out = self.cmd "sudo -u actian bash -c \"source ~actian/.ingAHsh; /opt/Actian/AnalyticsPlatformAH/ingres/bin/sql dbtest < #{self.query_file(q)}\" > log/vector/#{q}.out"
    end)[1] - @startup_time
    
    # If vector created the output file and it contains the success string, we return the time
    # otherwise nil to indicate an errorneus execution
    if File.exist?("log/vector/#{q}.out") && File.read("log/vector/#{q}.out").match(/Your SQL statement\(s\) have been committed/)
      return t
    else
      return nil
    end
  end
  
  def after_run(q)
    # Read the output file and transform it, such that only all before the first relevant and after
    # the last relevant line is deleted. After this step, the first and last line are only 
    # consisting only of +--+...
    s = File.read("log/vector/#{q}.out").gsub(/.*\n\n\+------/m, "").gsub(/\------\+\n\(.*/m, "------+")
    
    # Remove two first and last row
    s = s.lines[3..(s.lines.count-2)]
    
    # Remove the initial and final field separators and replace the inner field
    # separators with tabs
    s = s.join.gsub(/\A\|[ ]*/, '').gsub(/\n\|[ ]*/, "\n").gsub(/\|[ ]*\n/, "\n").gsub(/[ ]*\|[ ]*/, "\t")
    
    File.open("log/vector/#{q}.txt", 'w') {|f| f.write(s) }
    File.delete("log/vector/#{q}.out")
  end
end


class Array
  def median
    sorted = self.sort
    half_len = (sorted.length / 2.0).ceil
    (sorted[half_len-1] + sorted[-half_len]) / 2.0
  end
end