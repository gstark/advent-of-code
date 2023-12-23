Point = Data.define(:row, :col)

grid = ARGF.readlines(chomp: true).map(&:chars)

ALL_DIRECTIONS = [[0, -1], [0, 1], [-1, 0], [1, 0]]
START = Point.new(row: 0, col: 1)
TARGET = Point.new(row: grid.length - 1, col: grid[0].length - 2)

# Define a function to return the valid [row,col] neighbors
def valid_neighbors(grid, point, directions)
  directions
    .map { |dr, dc| Point.new(row: point.row + dr, col: point.col + dc) }
    .select { |point| point.row >= 0 && point.col >= 0 && point.row < grid.length && point.col < grid[0].length }
    .select { |point| grid[point.row][point.col] != "#" }
end

# Find all the points, including the start and end, that have more than two neighbors
#
# This leaves us with only the interesting points where we have a decision on a direction
# to take. Essentially turning out grid into a set of points to walk.
points = (0...grid.length).flat_map { |row| (0...grid[0].length).flat_map { |col| Point.new(row:, col:) } }
  .reject { |point| grid[point.row][point.col] == "#" }
  .select { |point| valid_neighbors(grid, point, ALL_DIRECTIONS).count > 2 }

points = Set.new([START, TARGET, *points])

# Create a hash of points to a hash of connected points to their distances
#
# e.g    (a,b) => (c,d) => 3
#              => (e,f) => 5
#        (c,d) => (g,h) => 8
graph = points.map { |point| [point, {}] }.to_h

# This next part is a bit like a flood fill
#
# We are starting with each point and flooding
# outward to see what points we can get to from
# there, and tracking their distance. We'll only
# add to the graph the points in our interesting
# set of points. Thus we'll end up with a graph
# data structure that tells us, for each point,
# where we can reach and how far away that
# other point is.

# Go through every source point
points.each do |source_point|
  # Keep a stack of points and their distances
  stack = [{distance: 0, point: source_point}]

  # And a set of points we've seen (for efficiency)
  seen = Set.new

  # While we have more points to consider
  while stack.any?
    # Get the next point and it's distance
    distance, destination_point = stack.pop.values_at(:distance, :point)

    # If we have a valid distance and this point is one we are
    # interested it, record the distance to this point and
    # move on to the next
    if distance > 0 && points.include?(destination_point)
      graph[source_point][destination_point] = distance
      next
    end

    # Go through the valid neighbors of the destination
    valid_neighbors(grid, destination_point, ALL_DIRECTIONS)
      # skip the ones we have seen
      .reject { |point| seen.include?(point) }
      # and push each one on the stack with a slightly larger distance
      .each { |point| stack.push({distance: distance + 1, point:}) }
      # and record that we've seen it
      .each { |point| seen << point }
  end
end

# Apply a depth first search for the target
# accumulating the distance from point to
# point along the way. As we go through
# we will keep the maximum distance.
def dfs(graph, current_point, points_seen_so_far)
  # If we are at the target, return a total distance of 0
  if current_point == TARGET
    return 0
  end

  # Create a new seen set mutated with the current point
  points_seen_so_far = points_seen_so_far.dup
  points_seen_so_far << current_point

  # Go through all the destinations we can reach from the
  # current point, rejecting any we've seen so far
  # and then compute the maximum to any of those points.
  # When we recurse we'll add the distance to the destination
  # point.
  graph[current_point]
    .reject { |point| points_seen_so_far.include?(point) }
    .reduce(-Float::INFINITY) { |max_so_far, (destination_point, distance)| [max_so_far, distance + dfs(graph, destination_point, points_seen_so_far)].max }
end

p dfs(graph, START, Set.new)
