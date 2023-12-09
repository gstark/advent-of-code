p $stdin
  .readlines
  .map { |line| line.split.map(&:to_i).reverse }
  .sum { |line|
    (
      result = []
      loop {
        result << line.last
        break result if line.uniq.length == 1
        line = line.each_cons(2).map { |a, b| b - a }
      }
    ).sum
  }
