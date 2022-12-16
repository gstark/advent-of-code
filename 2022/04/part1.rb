p ARGF.readlines(chomp: true)
  .map { |line| line.scan(/(\d+)-(\d+),(\d+)-(\d+)/).first }
  .map { |values| values.map(&:to_i) }
  .map { |(s1, e1, s2, e2)| [(s1..e1), (s2..e2)] }
  .count { |r1, r2| r1.cover?(r2) || r2.cover?(r1) }
