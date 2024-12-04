# Read the input, split it into an array of characters
p $stdin
  .readlines(chomp: true)
  .map { |line| line.chars }
  # Yield this grid to a block
  .yield_self { |grid|
    # For each row and for ach column we add up the number of matches inside the block
    (0..grid.size).sum { |row|
      (0..grid[0].size).sum { |col|
        # Iterate over each direction, up-and-left, up, up-and-right, left, right, down-and-left, down, down-and-right
        [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]].sum { |delta_row, delta_col|
          # We'll collect four characters
          (4.times
            # Turn each length (0, then 1, then 2, then 3) into an array of row, column pairs
            .map { |length| [row + delta_row * length, col + delta_col * length] }
            # Take out any that are out of bounds
            .filter { |neighbor_row, neighbor_col| neighbor_row >= 0 && neighbor_row < grid.size && neighbor_col >= 0 && neighbor_col < grid[0].size }
            # Turn the remaining good pairs into the character in the grid
            .map { |neighbor_row, neighbor_col| grid[neighbor_row][neighbor_col] }
            # Join them together and if this is XMAS, count it as 1, otherwise count it as 0
            .join == "XMAS") ? 1 : 0
        }
      }
    }
  }
