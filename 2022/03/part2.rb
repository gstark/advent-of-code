p ARGF.readlines(chomp: true)
  .each_slice(3)
  .map { |lines| lines.map(&:chars) }
  .map { |lines| lines.reduce(:&).first }
  .map { |priority| ("a".."z").cover?(priority) ? priority.ord - 96 : priority.ord - 64 + 26 }
  .sum
