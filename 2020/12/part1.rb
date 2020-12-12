INSTRUCTIONS = STDIN.readlines(chomp: true).flat_map { |line| line.scan(/([NSEWLRF])(\d+)/) }.map { |instruction, qty| [instruction, qty.to_i] }

x = 0
y = 0
angle = 90

DIRECTIONS = {
  0 => [0, 1],
  90 => [1, 0],
  180 => [0, -1],
  270 => [-1, 0],
}

INSTRUCTIONS.each do |instruction, qty|
  case instruction
  when "N" then y += qty
  when "S" then y -= qty
  when "E" then x += qty
  when "W" then x -= qty
  when "L" then angle = (angle - qty) % 360
  when "R" then angle = (angle + qty) % 360
  when "F"
    x += DIRECTIONS[angle][0] * qty
    y += DIRECTIONS[angle][1] * qty
  end
end

p x.abs + y.abs
