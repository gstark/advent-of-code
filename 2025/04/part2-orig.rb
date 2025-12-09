grid = $stdin.read.split("\n").map(&:chars)

def count_rolls(grid)
  deltas = (-1..1).flat_map { |dx| (-1..1).map { |dy| [dx, dy] } } - [[0, 0]]

  locations = []

  total = 0
  grid.each.with_index do |row, row_index|
    row.each.with_index do |col, col_index|
      count = deltas.count { |dx, dy| row_index + dx >= 0 && col_index + dy >=0 && row_index + dx < grid.length && col_index + dy < grid.length && grid[row_index + dx][col_index + dy] == "@" }

      if count < 4 && col == "@"
        total += 1
        locations << [row_index, col_index]
      end
    end
  end

  {total:, locations:}
end

total = 0
loop do
  result = count_rolls(grid)
  break if result[:total] == 0

  total += result[:total]
  grid = grid.map(&:dup)
  result[:locations].each do |location|
    grid[location[0]][location[1]] = "."
  end
end

p total
