grid = $stdin.read.split("\n").map(&:chars)

deltas = (-1..1).flat_map { |dx| (-1..1).map { |dy| [dx, dy] } } - [[0, 0]]

total = 0
grid.each.with_index do |row, row_index|
  row.each.with_index do |col, col_index|
    count = deltas.count { |dx, dy| row_index + dx >= 0 && col_index + dy >=0 && row_index + dx < grid.length && col_index + dy < grid.length && grid[row_index + dx][col_index + dy] == "@" }

    total += 1 if count < 4 && col == "@"
  end
end

p total
