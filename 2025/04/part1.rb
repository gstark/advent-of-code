require "grid"

grid = Grid.new($stdin.read)

total = grid.count do |_row, _col, element, neighbors|
  neighbor_count = neighbors.values.count { |n| n[:value] == "@" }
  neighbor_count < 4 && element == "@"
end

p total
