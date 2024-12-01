p $stdin
  .map { |line| line.split.map(&:to_i) }
  .transpose
  .yield_self { |lefts, rights| lefts.sum { |left| left * rights.count(left) } }
