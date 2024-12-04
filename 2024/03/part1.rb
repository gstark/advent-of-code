p $stdin.readlines.sum { |line| line.scan(/mul\((\d+),(\d+)\)/).sum { |a, b| a.to_i * b.to_i } }
