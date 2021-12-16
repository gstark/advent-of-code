require 'awesome_print'
require 'colorize'
require_relative './astar'

map = $stdin.readlines.map { |line| line.chars.map(&:to_i) }
map_length = map.length
full_map_length = map.length

# The heuristic that estimates the cost of the cheapest path from current to the goal.
# In fact this could just be a constant since both neighbors are equidistant to the goal.
heuristic = proc { |current| (full_map_length - current[0] - 1) + (full_map_length - current[1] - 1) }

# This is the weight of traveling from current to the neighbor, in this case it is just the weight of the neighbor
weight = proc { |current, neighbor|
   first_coord_in_first_quad  = neighbor[0] % map_length
   second_coord_in_first_quad = neighbor[1] % map_length
   value = map[first_coord_in_first_quad][second_coord_in_first_quad]

   first_quad_offset = neighbor[0] / map_length
   second_quad_offset = neighbor[1] / map_length

   new_value = (value + first_quad_offset + second_quad_offset)

   new_value > 9 ? new_value % 9 : new_value
}

# Returns the possible neighbors of the current element
# NOTE: I initially assumed that we would only ever go down and right, but in fact
#       the shortest cost might include some trips up and left.
neighbors = proc { |(r,c)| [[r,c+1], [r+1,c], [r-1,c], [r,c+1]].select { |(r,c)| r >= 0 && r < full_map_length && c >= 0 && c < full_map_length } }

result = a_star(start: [0,0],
                goal: [full_map_length - 1, full_map_length - 1],
                neighbors: neighbors,
                heuristic: heuristic,
                weight: weight)

ap result[:score]

# (0...full_map_length).map { |first| puts (0...full_map_length).map { |second| entry=[first,second]; path.include?(entry) ? weight.call(nil, [first,second]).to_s.yellow : weight.call(nil, [first,second]) }.join }