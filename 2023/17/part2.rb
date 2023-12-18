require_relative "astar"
require_relative "debug"

GRID = ARGF.readlines(chomp: true).map { |line| line.chars.map(&:to_i) }

heuristic = proc { |neighbor| 0 }
weight = proc { |current, neighbor| GRID[neighbor[:row]][neighbor[:col]] }
inspector = proc {}
goal = proc { |details| details[:row] == GRID.length - 1 && details[:col] == GRID[0].length - 1 && details[:last_same].length >= 4 && details[:last_same].first == details[:incoming_direction] }

neighbors = proc { |neighbor, path|
  row, col, incoming_direction = neighbor.values_at(:row, :col, :incoming_direction)

  deltas = [
    [0, 1, "right", "left"],
    [1, 0, "down", "up"],
    [0, -1, "left", "right"],
    [-1, 0, "up", "down"]
  ].reject { |_, _, _, opposite| opposite == incoming_direction }

  last_same = path
    .reverse_each
    .take_while { |details| details[:incoming_direction] == incoming_direction }
    .map { |details| details[:incoming_direction] }

  if last_same.length < 4 && incoming_direction != "none"
    deltas.select! { |_, _, name, _| name == incoming_direction }
  elsif last_same.length >= 10
    deltas.reject! { |_, _, name, _| name == last_same.first }
  end

  deltas
    .map { |dr, dc, name, _| {row: row + dr, col: col + dc, incoming_direction: name, last_same: last_same} }
    .select { |details| (0...GRID.length).cover?(details[:row]) && (0...GRID[0].length).cover?(details[:col]) }
}

result_a = a_star(
  start: {row: 0, col: 0, incoming_direction: "none", last_same: []},
  inspector:,
  goal:,
  neighbors:,
  heuristic:,
  weight:
)
result_a[:path].reject! { |details| details[:row] == 0 && details[:col] == 0 }
score_path(result_a[:path], print: true)
puts
