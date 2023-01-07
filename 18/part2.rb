require "set"

input = ARGF.readlines(chomp: true).map { |cube| cube.split(",").map(&:to_i) }

cubes = Set.new(input)

DIRS = [
  [0,0,1],
  [0,0,-1],
  [0,1,0],
  [0,-1,0],
  [1,0,0],
  [-1,0,0]
]

# Compute lower and upper bounds
lower = 3.times.map { |index| cubes.map { |cube| cube[index] }.min - 1 }
upper = 3.times.map { |index| cubes.map { |cube| cube[index] }.max + 1 }

# And a proc to determine if something is in our out
in_bound = proc { |cube| 3.times.all? { |index| cube[index].between?(lower[index], upper[index]) } }

seen = Set.new

# stack for searching positions
# We start with a position that is
# OUTSIDE the cube and we'll be depth
# first searching for all the position just
# outside of the structure
stack = [lower]

# While we have something to search
until stack.empty?
  # Take something off the stack
  current = stack.pop

  # If we haven't seen this element
  # and it isn't a cube
  # and it is in bounds
  if !seen.include?(current) && !cubes.include?(current) && in_bound[current]
    # Mark that we've seen it
    seen << current

    # Add all of it's neighbors to the search stack
    DIRS.map { |dir| current.zip(dir).map(&:sum) }.each { |new_cube| stack << new_cube }
  end
end

# Now go through all the neighbors of the cubes and count how many we've seen
# Since this will be the outside surface area. This is because all the positions
# in 'seen' are all the positions *outside* the cube.
p cubes.flat_map { |cube| DIRS.map { |dir| cube.zip(dir).map(&:sum) } }.count { |cube| seen.include?(cube) }
