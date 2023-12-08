p $stdin
  .readlines(chomp: true)
  .yield_self { |lines| [lines[0].chars.cycle, lines[2..].map { _1.scan(/\w+/) }.to_h { |source, left, right| [source, {left:, right:}] } ] }
  .yield_self { |directions, map|
    map
      .keys
      .select { |location| location.end_with?("A") }
      .map { |location| directions.find_index { |direction| (location = (direction == "L") ? map[location][:left] : map[location][:right]).end_with?("Z") } + 1 }
      .reduce(:lcm)
  }
