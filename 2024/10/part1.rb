map = $stdin.read.split("\n").map { |row| row.chars.map(&:to_i) }

DIRS = [[0, 1], [1, 0], [0, -1], [-1, 0]]

def is_path(grid, row, col, next_step, endings)
  count = 0

  DIRS.each do |delta_row, delta_col|
    next_row = row + delta_row
    next_col = col + delta_col

    # off grid
    next unless next_row >= 0 && next_row < grid.size && next_col >= 0 && next_col < grid[next_row].size

    # not the right step
    next if grid[next_row][next_col] != next_step

    # The right step and we are at an ending. Just don't extra count
    if grid[next_row][next_col] == 9 && next_step == 9 && !endings.include?([next_row, next_col])
      # Record this ending
      endings << [next_row, next_col]

      # increase our count
      count += 1
    end

    # Add the recursion of going in this direction
    count += is_path(grid, next_row, next_col, next_step + 1, endings)
  end

  # Return the count
  count
end

p (0...map.size).sum { |row| (0...map.size).sum { |col| (map[row][col] == 0) ? is_path(map, row, col, 1, Set.new) : 0 } }
