# This would be a nice Ruby enumerable method
#
# This maps through the enumerable, yielding the
# current element from "self" and the result of
# the previous iteration. You may provide a
# default value for previous to be used for
# the first iteration.
module Enumerable
  def map_with_previous(previous = nil)
    map do |element|
      (yield element, previous).tap do |new_element|
        previous = new_element
      end
    end
  end
end

p $stdin
  .read
  .split("\n\n")
  .yield_self { |direction_string, map_lines|
    [
      direction_string.chars.cycle,
      map_lines
        .split("\n")
        .map { _1.scan(/\w+/) }
        .to_h { |source, left, right| [source, {"L" => left, "R" => right}] }
    ]
  }
  .yield_self { |directions, map|
    map
      .keys
      .select { |location| location.end_with?("A") }
      .map { |location|
        directions
          .lazy
          .map_with_previous(location) { |direction, location| map[location][direction] }
          .find_index { |location| location.end_with?("Z") } + 1
      }
      .reduce(:lcm)
  }
