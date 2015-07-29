require_relative 'benchmark'

class MemsqlBenchmark < Benchmark
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

    query = File.read(self.query_file(q))
    out = self.cmd "mysql -u root -h scyper2.informatik.tu-muenchen.de -P 3306 -vvv -D tpch < #{self.query_file(q)}"
    File.open("log/#{self.name}/#{q}.out", 'w') {|f| f.write(out) }

    # If memsql created the output file and it contains the success string, we return the time
    # otherwise nil to indicate an errorneus execution
    if !out.match(/Error/)
      match = out.scan(/\((\d+\.\d+) sec\)/)
      if match
        sum = 0.0
        match.each do |m|
          sum += m[0].to_f
        end
        return sum
      end
    end
    return nil
  end

  def after_run(q)
    # Read the output file
    s = File.read("log/#{self.name}/#{q}.out")

    # Handle empty result
    if s.match(/Empty set/)
      s = ""
    else
      # Remove lines before the first relevant and after the last relevant line. After this step, the
      # first and last line are only consisting only of +--+...
      s = s.gsub(/.*\n\n\+------/m, "").gsub(/\------\+\n\(.*/m, "------+")

      # Remove two first and last row
      s = s.lines[3..(s.lines.count-5)].join

      # Remove the initial and final field separators and replace the inner field separators with tabs
      s = s.gsub(/\A\|[ ]*/, '').gsub(/\n\|[ ]*/, "\n").gsub(/\|[ ]*\n/, "\n").gsub(/[ ]*\|[ ]*/, "\t")
    end

    # Write result to file
    File.open("log/#{self.name}/#{q}.txt", 'w') {|f| f.write(s) }
    File.delete("log/#{self.name}/#{q}.out")
  end
end
