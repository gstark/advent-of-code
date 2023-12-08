p $stdin
  .readlines(chomp: true)
  .yield_self { |lines| [lines[0].chars.cycle, lines[2..].map { _1.scan(/\w+/) }.to_h { |source, left, right| [source, {left:, right:}] } ] }
  .yield_self { |directions, map|
    map
      .keys
      .select { |entry| entry.end_with?("A") }
      .map { |current| directions.find_index { |direction| (current = (direction == "L") ? map[current][:left] : map[current][:right]).end_with?("Z") } + 1 }
      .reduce(:lcm)
  }
