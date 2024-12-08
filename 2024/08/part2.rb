grid = $stdin.readlines(chomp: true).map(&:chars)

grid_size = grid.size

antennas = {}
grid.size.times do |row_index|
  grid.size.times do |col_index|
    spot = grid[row_index][col_index]
    if spot != "." && spot != "#"
      antennas[spot] ||= []

      antennas[spot] << [row_index, col_index]
    end
  end
end

nodes = Set.new
antennas.each do |antenna, spots|
  spots.combination(2).each do |spot1, spot2|
    spot1, spot2 = spot2, spot1 if spot1[0] > spot2[0]

    up = (spot1[0] - spot2[0]).abs
    over = (spot1[1] - spot2[1]).abs

    (1..grid_size).each do |multiplier|
      if spot1[1] < spot2[1]
        antinode_1 = [spot1[0] - up * multiplier, spot1[1] - over * multiplier]
        antinode_2 = [spot2[0] + up * multiplier, spot2[1] + over * multiplier]
      else
        antinode_1 = [spot1[0] - up * multiplier, spot1[1] + over * multiplier]
        antinode_2 = [spot2[0] + up * multiplier, spot2[1] - over * multiplier]
      end
      nodes << antinode_1 if antinode_1[0].between?(0, grid_size - 1) && antinode_1[1].between?(0, grid_size - 1)
      nodes << antinode_2 if antinode_2[0].between?(0, grid_size - 1) && antinode_2[1].between?(0, grid_size - 1)
    end

    # The spots themselves will be antinodes of each other
    nodes << spot1
    nodes << spot2
  end
end

# nodes.each do |a, b|
#   grid[a][b] = "#"
# end
# puts grid.map(&:join).join("\n")

p nodes.size
