p $stdin
  .readlines
  .map { |line| line.split.map(&:to_i) }
  .sum { |line|
    (
      result = []
      (0..).map {
        result << line.last
        line = line.each_cons(2).map { |a, b| b - a }
        if line.uniq.length == 1
          result << line.last
          break result
        end
      }
    ).sum
  }
