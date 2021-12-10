require 'awesome_print'
require 'set'

heights = $stdin.read.
                 split("\n").
                 map(&:chars).
                 map.
                 with_index { |row, row_index| row.map.with_index { |height, col_index| [[row_index, col_index], height.to_i] } }.
                 flatten(1).
                 to_h

# basin size is 1 + sum of the basin size of all the non-nine-elements-around me

def basin_size(row, col, heights, visited = Set.new)
  return 0 if heights[[row,col]].nil? ||
              visited.include?([row,col]) ||
              heights[[row,col]] == 9

  visited << [row, col]

  1 + basin_size(row-1, col+0, heights, visited) +
      basin_size(row+1, col+0, heights, visited) +
      basin_size(row+0, col-1, heights, visited) +
      basin_size(row+0, col+1, heights, visited)
end

ap heights.
    select { |(row, col), height|
      [
        heights[[row-1, col+0]],
        heights[[row+1, col+0]],

        heights[[row+0, col-1]],
        heights[[row+0, col+1]],
      ].compact.all? { |neighbor| neighbor > height }
    }.
    map { |(row, col), height| basin_size(row, col, heights) }.
    max(3).
    reduce(:*)
