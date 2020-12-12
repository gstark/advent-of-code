INSTRUCTIONS = STDIN.readlines(chomp: true).flat_map { |line| line.scan(/([NSEWLRF])(\d+)/) }.map { |instruction, qty| [instruction, qty.to_i] }

x = 0
y = 0

dx = 10
dy = 1

INSTRUCTIONS.each do |instruction, qty|
  case instruction
  when "N" then dy += qty
  when "S" then dy -= qty
  when "E" then dx += qty
  when "W" then dx -= qty
  when "L" then (qty / 90).times { dx, dy = [-dy, dx] }
  when "R" then (qty / 90).times { dx, dy = [dy, -dx] }
  when "F"
    x += dx * qty
    y += dy * qty
  end
end

p x.abs + y.abs
