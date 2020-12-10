JOLTS = STDIN.readlines.map(&:to_i)

counts = JOLTS.sort.each_cons(2).map { |lower, higher| higher - lower }.tally

p (counts[3] + 1) * (counts[1] + 1)
