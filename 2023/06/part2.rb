p STDIN.readlines
  .map { |line| line.split(":").last.delete(" ").to_i }
  .yield_self { |(time, distance)|
    time.times.map { |speed| [speed, (time-speed)*speed] }.reject { |speed, new_distance| new_distance <= distance }.count
  }