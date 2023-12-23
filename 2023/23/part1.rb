require_relative "astar"

grid = ARGF.readlines(chomp: true).map(&:chars)

# Define a function to return the valid [row,col] neighbors
def valid_neighbors(grid, row, col, directions)
  directions
    .map { |dr, dc| [row + dr, col + dc] }
    .select { |row, col| row >= 0 && col >= 0 && row < grid.length && col < grid[0].length }
    .select { |row, col| grid[row][col] != "#" }
end

height = grid.length
width = grid[0].length

start_row = 0
start_col = 1
target_row = height - 1
target_col = width - 2
queue = [[start_row, start_col, Set.new]]

walks = []
while queue.any?
  row, col, path = queue.pop

  if [row, col] == [target_row, target_col]
    walks << path.length
  end

  directions = case grid[row][col]
  when ">" then [[0, 1]]
  when "<" then [[0, -1]]
  when "v" then [[1, 0]]
  when "^" then [[-1, 0]]
  else [[0, -1], [0, 1], [-1, 0], [1, 0]]
  end

  valid_neighbors(grid, row, col, directions)
    .select { |row, col| !path.include?([row, col]) }
    .each { |row, col| queue << [row, col, Set.new([*path, [row, col]])] }
end

p walks.max
