MIN = STDIN.gets.to_i
BUSSES = STDIN.gets.split(",").reject { |bus| bus == "x" }.map(&:to_i)

p BUSSES.map { |bus| [(MIN / bus + 1) * (bus) - MIN, bus] }.min.reduce(:*)
