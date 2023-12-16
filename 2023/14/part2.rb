grid = ARGF
  .readlines(chomp: true)
  .map(&:chars)

def tilt_north(grid)
  (0...grid[0].length).each do |col|
    move_to = 0
    (0...grid.length).each do |row|
      if grid[row][col] == "O"
        grid[row][col] = "."
        grid[move_to][col] = "O"
        move_to += 1
      elsif grid[row][col] == "#"
        move_to = row + 1
      end
    end
  end
end

def tilt_south(grid)
  (0...grid[0].length).each do |col|
    move_to = grid.length - 1
    (grid.length - 1).downto(0).each do |row|
      if grid[row][col] == "O"
        grid[row][col] = "."
        grid[move_to][col] = "O"
        move_to -= 1
      elsif grid[row][col] == "#"
        move_to = row - 1
      end
    end
  end
end

def tilt_east(grid)
  (0...grid.length).each do |row|
    move_to = grid[0].length - 1
    (grid[0].length - 1).downto(0).each do |col|
      if grid[row][col] == "O"
        grid[row][col] = "."
        grid[row][move_to] = "O"
        move_to -= 1
      elsif grid[row][col] == "#"
        move_to = col - 1
      end
    end
  end
end

def tilt_west(grid)
  (0...grid.length).each do |row|
    move_to = 0
    (0...grid[0].length).each do |col|
      if grid[row][col] == "O"
        grid[row][col] = "."
        grid[row][move_to] = "O"
        move_to += 1
      elsif grid[row][col] == "#"
        move_to = col + 1
      end
    end
  end
end

def cycle(grid)
  tilt_north(grid)
  tilt_west(grid)
  tilt_south(grid)
  tilt_east(grid)
end

seen = {}
count = 0
TARGET = 1_000_000_000
while count < TARGET
  count += 1
  cycle(grid)

  # If we've seen this grid before we've formed
  # a loop, so march forward as many loop lengths
  # as we can until one more would put is PAST
  # the target. Then we'll just loop a few more
  # times until we get to the target.
  if seen.key?(grid)
    loop_length = count - seen[grid]
    count += (TARGET - count) / loop_length * loop_length
  else
    # If we haven't been here, then record
    # this location and count
    seen[grid.map(&:dup)] = count
  end
end

score = (0...grid.length).sum { |row| (grid.length - row) * grid[row].count("O") }
p score
