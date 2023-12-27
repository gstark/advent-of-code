input = ARGF.readlines(chomp: true)

# Convert the inputs to positions and velocities
# Then compute both `m` and `b` for y = mx + b
lines = input
  .map { |line| line.split("@") }
  .map { |line, velocity| {**line.split(",").map(&:to_f).yield_self { |(x, y, z)| {x:, y:, z:} }, **velocity.split(",").map(&:to_f).yield_self { |(dx, dy, dz)| {dx:, dy:, dz:} }} }
  .map { |details| {**details, m: details[:dy] / details[:dx]} }
  .map { |details| {**details, b: details[:y] - details[:m] * details[:x]} }

min = 200000000000000
max = 400000000000000
# min = 7
# max = 27

count = lines.combination(2).count do |line1, line2|
  # Same slope, so nope!
  if line1[:m] == line2[:m]
    false
  else
    # compute intercept for x using  mx1 * x + b1 = mx2 * x + b2, solve for x
    intercept_x = (line2[:b] - line1[:b]) / (line1[:m] - line2[:m])

    # compute intercept for y by putting our x intercept into either y = mx + b
    intercept_y = line1[:m] * intercept_x + line1[:b]

    # Determine if the dx and dy are taking us in the correct directions
    correct_direction_x1 = line1[:x] > intercept_x && line1[:dx] < 0 || line1[:x] < intercept_x && line1[:dx] > 0
    correct_direction_x2 = line2[:x] > intercept_x && line2[:dx] < 0 || line2[:x] < intercept_x && line2[:dx] > 0
    correct_direction_y1 = line1[:y] > intercept_y && line1[:dy] < 0 || line1[:y] < intercept_y && line1[:dy] > 0
    correct_direction_y2 = line2[:y] > intercept_y && line2[:dy] < 0 || line2[:y] < intercept_y && line2[:dy] > 0

    # If our intercepts are in the correct target range
    inside_target = (min..max).cover?(intercept_x) && (min..max).cover?(intercept_y)

    # truth
    correct_direction_x1 && correct_direction_x2 && correct_direction_y1 && correct_direction_y2 && inside_target
  end
end

p count
