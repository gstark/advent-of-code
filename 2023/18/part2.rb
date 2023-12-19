plan = ARGF
  .readlines(chomp: true)
  .map(&:split)
  # Map special parsing of input
  .map { |direction, _, color| [{"0" => "R", "1" => "D", "2" => "L", "3" => "U"}[color[-2]], color[2..6].to_i(16)] }

# Lookup table
DIRS = {
  "D" => {x: 0, y: -1},
  "U" => {x: 0, y: 1},
  "L" => {x: -1, y: 0},
  "R" => {x: 1, y: 0}
}

# Start here
coords = [{x: 0, y: 0}]

# Go through each instruction, building up a set of coordinates
plan.each do |direction, length|
  coords << {x: coords.last[:x] + DIRS[direction][:x] * length, y: coords.last[:y] + DIRS[direction][:y] * length}
end

# Shoelace formula for area: https://en.wikipedia.org/wiki/Shoelace_formula
area = 0.5 * (1...coords.length - 1).sum { |i| coords[i][:x] * (coords[i + 1][:y] - coords[i - 1][:y]) }.abs

# Picks theorem solved for interior points: https://en.wikipedia.org/wiki/Pick%27s_theorem
boundary = plan.sum { |_, length, _| length }
interior = area - boundary / 2 + 1

# Add the interior plus the boundary
p (interior + boundary).to_i
