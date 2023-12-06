# A more direct way is to solve the equation
#
# -speed^2 +/- 7*speed - 9 > 0
#
# So we'll use quadratic formula to determine the high and low range
#
p STDIN.readlines
  .map { |line| line.split(":").last.delete(" ").to_i }
  .yield_self { |(time, distance)|
    # Brute force:
    # time.times.map { |speed| [speed, (time-speed)*speed] }.reject { |speed, new_distance| new_distance <= distance }.count

    ((-time - Math.sqrt(time**2 - 4*distance))/(-2)).floor + 1 - ((-time + Math.sqrt(time**2 - 4*distance))/(-2)).ceil
  }