plan = ARGF
  .readlines(chomp: true)
  .map(&:split)
  .map { |direction, length| [direction, length.to_i] }

# Lookup table
DIRS = {
  "D" => {x: 0, y: 1},
  "U" => {x: 0, y: -1},
  "L" => {x: -1, y: 0},
  "R" => {x: 1, y: 0}
}

# Start here
coords = [{x: 0, y: 0}]

# Go through each instruction, building up a set of coordinates
plan.each do |direction, length|
  coords << {x: coords.last[:x] + DIRS[direction][:x] * length, y: coords.last[:y] + DIRS[direction][:y] * length}
end

p coords

# Shoelace formula for area: https://en.wikipedia.org/wiki/Shoelace_formula
area = 0.5 * (1...coords.length - 1).sum { |i| coords[i][:x] * (coords[i + 1][:y] - coords[i - 1][:y]) }.abs

# Picks theorem solved for interior points: https://en.wikipedia.org/wiki/Pick%27s_theorem
boundary = plan.sum { |_, length| length }
interior = area - boundary / 2 + 1

# Add the interior plus the boundary
p({area:, boundary:, interior:})
p (interior + boundary).to_i
