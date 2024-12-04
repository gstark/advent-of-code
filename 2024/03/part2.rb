p $stdin
    .readlines
    .each
    .with_object({total: 0, counting: true}) { |line, state|
      line.scan(/do\(\)|don't\(\)|mul\(\d+,\d+\)/) { |match|
        case match
        when "do()" then state[:counting] = true
        when "don't()" then state[:counting] = false
        else state[:total] += match.scan(/\d+/).map(&:to_i).reduce(:*) if state[:counting]
        end
      }
    }.fetch(:total)
