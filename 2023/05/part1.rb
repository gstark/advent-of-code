seeds = STDIN.readline.split(":").last.split.map(&:to_i)

maps = STDIN
  .readlines(chomp: true)
  .chunk_while { |a,b| b != "" }
  .map { |lines| lines[2..].map(&:split).map { |dest, source, length| [source.to_i..source.to_i+length.to_i, dest.to_i - source.to_i]} }

p seeds.map { |start| maps.reduce(start) { |number, ranges| new_number = number + (ranges.find { |source, dest| source.include?(number) } || [0,0])[1] } }.min