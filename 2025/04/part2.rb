require_relative "../../lib/grid"

grid = Grid.new($stdin.read)

total = 0
loop do
  locations = grid.map { |row, col, value| value == "@" && (grid.neighbors(row, col).values.count("@") < 4) ? [row, col] : nil }.compact
  break if locations.empty?

  total += locations.size
  grid = grid.dup

  locations.each { |row, col| grid[row, col] = "." }
end

p total
