require_relative 'benchmark'

class VectorBenchmark < Benchmark
  def verify_ignore_first_line
    return false
  end

  def verify_epsilon
    return 0.0001
  end

  def verify_trim_strings
    return true
  end

  def perform_run(q)
    return nil if not File.exist? self.query_file(q)

    self.cmd "sudo -u actian bash -c \"source ~actian/.ingAHsh; /opt/Actian/AnalyticsPlatformAH/ingres/bin/sql tpch < #{self.query_file(q)}\" > log/#{self.name}/#{q}.out"

    # If vector created the output file and it contains the success string, we return the time
    # otherwise nil to indicate an errorneus execution
    if File.exist?("log/vector/#{q}.out") && File.read("log/vector/#{q}.out").match(/Your SQL statement\(s\) have been committed/)
      out = `grep "0 00:00:" log/#{self.name}/#{q}.out | tail -n 1`
      match = out.match(/0 00\:00\:(\d+(?:\.\d+){0,1})/)
      if match
        return match.captures[0].to_f
      end
    end
    return nil
  end

  def after_run(q)
    # Read the output file
    s = File.read("log/#{self.name}/#{q}.out")

    # Remove rows with execution time
    s = s.lines[0..(s.lines.count-14)].join

    # Remove lines before the first relevant and after the last relevant line. After this step, the
    # first and last line are only consisting only of +--+...
    s = s.gsub(/.*\n\n\+------/m, "").gsub(/\------\+\n\(.*/m, "------+")

    # Remove two first and last row
    s = s.lines[3..(s.lines.count-2)].join

    # Remove the initial and final field separators and replace the inner field separators with tabs
    s = s.gsub(/\A\|[ ]*/, '').gsub(/\n\|[ ]*/, "\n").gsub(/\|[ ]*\n/, "\n").gsub(/[ ]*\|[ ]*/, "\t")

    # Write result to file
    File.open("log/#{self.name}/#{q}.txt", 'w') {|f| f.write(s) }
    File.delete("log/#{self.name}/#{q}.out")
  end
end
