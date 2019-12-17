require "awesome_print"

asteroids = ARGF.readlines.flat_map.with_index { |line, row_index| line.chars.map.with_index { |char, index| [char == "#", index] }.select(&:first).flat_map(&:last).map { |index| [row_index, index] } }
p asteroids
