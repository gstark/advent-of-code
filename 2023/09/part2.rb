p $stdin
  .readlines
  .map { |line| line.split.map(&:to_i) }
  .map { |line|
    (
      result = []
      (0..).map {
        result << line.first
        break result if line.uniq.length == 1
        line = line.each_cons(2).map { |a, b| b - a }
      }
    )
      .reverse
      .reduce { |number, answer| answer - number }
  }
  .sum

# [10, 3, 0, 2]
# [2, 0, 3, 10]
# [2, -2, 5, 5]
