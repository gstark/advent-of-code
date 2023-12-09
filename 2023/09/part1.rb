p $stdin
  .readlines
  .map { |line| line.split.map(&:to_i) }
  .sum { |line|
    (
      result = []
      (0..).map {
        result << line.last
        break result if line.uniq.length == 1
        line = line.each_cons(2).map { |a, b| b - a }
      }
    ).sum
  }
