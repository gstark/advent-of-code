grid = $stdin
  .readlines(chomp: true)
  .map(&:chars)

row = grid.find_index { |row| row.include?("^") }
col = grid[row].find_index { |col| col == "^" }

GRID_SIZE = grid.size * grid[0].size
start_row, start_col = row, col

ALL_DIRECTIONS = [[-1, 0], [0, 1], [1, 0], [0, -1]]

def inside_grid?(grid, row, col)
  row >= 0 && col >= 0 && row < grid.size && col < grid[row].size
end

def simulate(grid, start_row, start_col, obstruction_row, obstruction_col)
  return false unless inside_grid?(grid, obstruction_row, obstruction_col)

  row, col = start_row, start_col

  directions = ALL_DIRECTIONS.cycle
  grid = grid.map { |row| row.map(&:dup) }

  grid[obstruction_row][obstruction_col] = "#"

  direction = directions.next
  steps = 0
  while inside_grid?(grid, row, col)
    next_row, next_col = row + direction[0], col + direction[1]

    steps += 1

    if grid[next_row] && grid[next_row][next_col] == "#"
      direction = directions.next
      next
    end

    return true if steps > GRID_SIZE

    row, col = next_row, next_col
  end

  false
end

obstacles = Set.new
directions = ALL_DIRECTIONS.cycle
direction = directions.next

while inside_grid?(grid, row, col)
  next_row, next_col = row + direction[0], col + direction[1]

  obstacles << [next_row, next_col] if simulate(grid, start_row, start_col, next_row, next_col)

  if grid[next_row] && grid[next_row][next_col] == "#"
    direction = directions.next
  else
    row, col = next_row, next_col
  end
end

p obstacles.size
