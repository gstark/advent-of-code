p $stdin
  .readlines(chomp: true)
  .yield_self { |lines| [lines[0].chars.cycle, lines[2..].map { _1.scan(/\w+/) }.to_h { |source, left, right| [source, {left:, right:}] } ] }
  .yield_self { |directions, map| ["AAA"].map { |location| directions.find_index { |direction| (location = (direction == "L") ? map[location][:left] : map[location][:right]) == "ZZZ" } } }.first + 1
