require 'awesome_print'

input = $stdin.read.split("\n").map { |line| line.split(" | ").last }

# ap input.count { |line| line.length == 4 || line.length == 7 || line.length == 3 || line.length == 2}
ap input.map { |line| line.split(" ") }.flatten.count { |line| [4,7,3,2].include?(line.length) }