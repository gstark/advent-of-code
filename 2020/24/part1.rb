require "set"

input = STDIN.readlines(chomp: true)

black_squares = Set.new()

input.each do |line|
  x, y = [0.0, 0.0]
  instructions = line.scan(/(e|se|sw|w|nw|ne)/).flatten
  instructions.each do |instruction|
    case instruction
    when "e"
      x += 1
    when "w"
      x -= 1
    when "ne"
      x += 0.5
      y += 0.5
    when "se"
      x += 0.5
      y -= 0.5
    when "sw"
      x -= 0.5
      y -= 0.5
    when "nw"
      x -= 0.5
      y += 0.5
    else
      raise "Ooops #{instruction}"
    end
  end
  if black_squares.include?([x, y])
    black_squares.delete([x, y])
  else
    black_squares << [x, y]
  end
end

p black_squares
p black_squares.size
