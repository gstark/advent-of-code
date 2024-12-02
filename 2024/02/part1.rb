p $stdin
  .each_line
  .map { |line| line.split.map(&:to_i) }
  .map { |report| (report[1] > report[0]) ? report : report.reverse }
  .filter { |report| report.sort == report }
  .count { |report| report.each_cons(2).all? { |a, b| (b - a).between?(1, 3) } }
