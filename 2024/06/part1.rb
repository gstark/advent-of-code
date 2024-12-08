grid = $stdin
  .readlines(chomp: true)
  .map(&:chars)

row = grid.find_index { |row| row.include?("^") }
col = grid[row].find_index { |col| col == "^" }

steps = 0
directions = [[-1, 0], [0, 1], [1, 0], [0, -1]].cycle
direction = directions.next

def inside_grid?(grid, row, col)
  row >= 0 && col >= 0 && row < grid.size && col < grid[row].size
end

while inside_grid?(grid, row, col)
  next_row, next_col = row + direction[0], col + direction[1]

  if inside_grid?(grid, next_row, next_col) && grid[next_row][next_col] == "#"
    direction = directions.next
  else
    steps += 1 unless grid[row][col] == "X"
    grid[row][col] = "X"

    row, col = next_row, next_col
  end
end

p steps
