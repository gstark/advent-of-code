grid = ARGF
  .readlines(chomp: true)
  .map(&:chars)

total = 0
(0...grid[0].length).each do |col|
  weight = grid.length
  (0...grid.length).each do |row|
    if grid[row][col] == "O"
      total += weight
      weight -= 1
    elsif grid[row][col] == "#"
      weight = grid.length - row - 1
    end
  end
end
p total
