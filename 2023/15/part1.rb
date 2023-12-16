line = ARGF.read.chomp

p line
  .split(",")
  .sum { |segment| segment.chars.reduce(0) { |value, char| (value + char.ord) * 17 % 256 } }
