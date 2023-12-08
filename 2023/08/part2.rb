p $stdin
  .read
  .split("\n\n")
  .yield_self { |direction_string, map_lines| [direction_string.chars.cycle, map_lines.split("\n").map { _1.scan(/\w+/) }.to_h { |source, left, right| [source, {"L" => left, "R" => right}] } ] }
  .yield_self { |directions, map|
    map
      .keys
      .select { |location| location.end_with?("A") }
      .map { |location| directions.find_index { |direction| (location = map[location][direction]).end_with?("Z") } + 1 }
      .reduce(:lcm)
  }
