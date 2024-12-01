p $stdin
  .map { |line| line.split.map(&:to_i) }
  .transpose
  .yield_self { |lefts, rights| [lefts.sort, rights.sort] }
  .yield_self { |lefts, rights| lefts.zip(rights) }
  .sum { |left, right| (left - right).abs }
