p $stdin
  .readlines
  .map { |line| line.split.map(&:to_i) }
  .sum { |line|
    (
      result = []
      loop {
        result << line.first
        break result if line.uniq.length == 1
        line = line.each_cons(2).map { |a, b| b - a }
      }
    )
      .reverse
      .reduce { |number, answer| answer - number }
  }
