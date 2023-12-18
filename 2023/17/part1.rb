require_relative "astar"
require_relative "debug"

GRID = ARGF.readlines(chomp: true).map { |line| line.chars.map(&:to_i) }

# Constant heuristic
heuristic = proc { |neighbor| 0 }

# Weight is the cost to go to the neighbor
weight = proc { |_, neighbor| GRID[neighbor[:row]][neighbor[:col]] }

# No inspector (useful for debugging)
inspector = proc {}

# Goal is that we've made it to the bottom right corner
goal = proc { |details| details[:row] == GRID.length - 1 && details[:col] == GRID[0].length - 1 }

# Compute neighbors
neighbors = proc { |neighbor, path|
  # Extract the row, column, and incoming direction
  row, col, incoming_direction = neighbor.values_at(:row, :col, :incoming_direction)

  # delta_row, delta_col, outgoing direction, opposite direction
  deltas = [
    [0, 1, "right", "left"],
    [1, 0, "down", "up"],
    [0, -1, "left", "right"],
    [-1, 0, "up", "down"]
  ]

  # Find the elements at the end of the path all going in the same direction
  last_same = path
    .reverse_each
    .take_while { |details| details[:incoming_direction] == incoming_direction }
    .map { |details| details[:incoming_direction] }

  # Reject any deltas that would take us right back in the same direction
  deltas.reject! { |_, _, _, opposite| opposite == incoming_direction }

  # If we've gone at least three in the current direction, we'll remove that from the possibilities
  if last_same.length >= 3
    deltas.reject! { |_, _, name, _| name == last_same.first }
  end

  # Generate neighbors with new row, col, incoming direction, and last_same
  # the incoming direction and "last same" are important for caching.
  deltas
    .map { |delta_row, delta_col, name, _| {row: row + delta_row, col: col + delta_col, incoming_direction: name, last_same: last_same} }
    .select { |details| (0...GRID.length).cover?(details[:row]) && (0...GRID[0].length).cover?(details[:col]) }
}

result = a_star(
  start: {row: 0, col: 0, incoming_direction: "none", last_same: []},
  inspector:,
  goal:,
  neighbors:,
  heuristic:,
  weight:
)
score_path(result[:path], print: true)
puts result[:score]
