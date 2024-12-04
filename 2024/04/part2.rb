# Read the input, split it into an array of characters
p $stdin
  .readlines(chomp: true)
  .map { |line| line.chars }
  # Yield this grid to a block
  .yield_self { |grid|
    # For each row and for ach column we add up the number of matches inside the block
    (0..grid.size).sum { |row|
      (0..grid[0].size).sum { |col|
        # For each possible point in the X (current position, two to the right, down one and over one, down two, and down two over two)
        [[0, 0], [0, 2], [1, 1], [2, 0], [2, 2]]
          # Turn that into a point in the grid
          .map { |delta_row, delta_col| [row + delta_row, col + delta_col] }
          # Filter out any that are out of bounds
          .filter { |neighbor_row, neighbor_col| neighbor_row >= 0 && neighbor_row < grid.size && neighbor_col >= 0 && neighbor_col < grid[0].size }
          # Turn the remaining good pairs into the character in the grid
          .map { |neighbor_row, neighbor_col| grid[neighbor_row][neighbor_col] }
          # Join the characters into a word
          .join
          # If this is any of the possible representations of the crossing patter, count it as 1, otherwise 0
          .yield_self { |word| ["MSAMS", "SSAMM", "MMASS", "SMASM"].include?(word) ? 1 : 0 }
      }
    }
  }
