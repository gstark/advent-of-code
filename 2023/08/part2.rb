p $stdin
  .readlines(chomp: true)
  .yield_self { |lines| [lines[0].chars.cycle, lines[2..].to_h { |line| [line[0..2], {left: line[7..9], right: line[12..14]}] }] }
  .yield_self { |directions, map|
    map
      .keys
      .select { |entry| entry.end_with?("A") }
      .map { |current|
      directions.find_index { |direction|
        (current = (direction == "L") ? map[current][:left] : map[current][:right]).end_with?("Z")
      } + 1
    }.reduce(:lcm)
  }
