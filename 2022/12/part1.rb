require "pastel"
require_relative "./astar"

map = ARGF.readlines(chomp: true).map(&:chars)

def find(map, letter)
  row = map.find_index { |line| line.index(letter) }
  col = map[row].index(letter)

  [row, col]
end

start = find(map, "S")
goal = find(map, "E")

# Make the start and end equivalent to their elevations
map[start[0]][start[1]] = "a"
map[goal[0]][goal[1]] = "z"

neighbors = proc do |(pos_row, pos_col)|
  valid = []
  current = map[pos_row][pos_col]

  [[-1, 0], [1, 0], [0, 1], [0, -1]].each do |(delta_row, delta_col)|
    new_row = delta_row + pos_row
    new_col = delta_col + pos_col
    next if new_row < 0 || new_col < 0 || new_row >= map.length || new_col >= map[0].length

    delta_value = map[new_row][new_col]

    if delta_value.ord - current.ord <= 1 || delta_value < current
      valid << [new_row, new_col]
    end
  end

  valid
end

heuristic = proc do |(pos_row, pos_col)|
  (goal[0] - pos_row).abs + (goal[1] - pos_col).abs
end

weight = proc do |(r1, c1), (r2, c2)|
  current = map[r1][c1]
  neighbor = map[r2][c2]

  # If we are climbing, this is a low weight
  if neighbor > current
    1
  # If we are staying even, a slightly higher weight
  elsif current == neighbor
    2
  # if we are lowering down, a slightly higher weight still
  else
    3
  end
end

# The weight function doesn't *really* matter
weight = proc { 1 }

result = a_star(start: start, goal: goal, neighbors: neighbors, heuristic: heuristic, weight: weight, inspector: proc {}, visit: proc {})

p result[:score]
p result[:path].length
p result[:path].each_cons(2).to_a.length

pastel = Pastel.new

map.each.with_index do |row, row_index|
  row.each.with_index do |col, col_index|
    if result[:path].include?([row_index, col_index])
      print pastel.bold(col)
    else
      print pastel.dim(col)
    end
  end
  puts
end
