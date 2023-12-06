p STDIN.readlines
  .map { |line| line.split.map(&:to_i) }
  .map { |line| line[1..] }
  .yield_self { |lines| lines.first.zip(lines.last) }
  .map { |(time, distance)|
    time.times.map { |speed| [speed, (time-speed)*speed] }.reject { |speed, new_distance| new_distance <= distance }.count
  }.reduce(&:*)