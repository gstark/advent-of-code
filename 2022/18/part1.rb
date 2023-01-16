require "set"

input = ARGF.readlines(chomp: true).map { |cube| cube.split(",").map(&:to_i) }

cubes = input.map { |line| {coords: line, faces: 6}}

cubes.combination(2).each do |a, b|
  if a[:coords][0] == b[:coords][0] && a[:coords][1] == b[:coords][1] && (a[:coords][2] - b[:coords][2]).abs == 1
    a[:faces] -= 1
    b[:faces] -= 1
  end
  if a[:coords][0] == b[:coords][0] && (a[:coords][1] - b[:coords][1]).abs == 1 && a[:coords][2] == b[:coords][2]
    a[:faces] -= 1
    b[:faces] -= 1
  end
  if (a[:coords][0] - b[:coords][0]).abs == 1 && a[:coords][1] == b[:coords][1] && a[:coords][2] == b[:coords][2]
    a[:faces] -= 1
    b[:faces] -= 1
  end
end

p cubes.map { |a| a[:faces] }.sum

# Here is another algorithm that uses a direction map to
# look at all the spaces around each cube and see if those
# are in the set of cubes. Has the benefit of being a 1-liner

cubes = Set.new(input)

DIRS = [
  [0,0,1],
  [0,0,-1],
  [0,1,0],
  [0,-1,0],
  [1,0,0],
  [-1,0,0]
]

p cubes.flat_map { |cube| DIRS.map { |dir| cube.zip(dir).map(&:sum) } }.count {|cube| !cubes.include?(cube)}
