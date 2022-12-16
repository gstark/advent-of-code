p ARGF.readlines(chomp: true)
  .map(&:chars)
  .map { |line| line.partition.with_index { |char, index| index < line.length / 2 } }
  .map { |(left, right)| left & right }
  .map(&:first)
  .map { |priority| ("a".."z").cover?(priority) ? priority.ord - 96 : priority.ord - 64 + 26 }
  .sum
