require 'awesome_print'
require 'colorize'
require 'set'
require 'pqueue'

map = $stdin.readlines.map { |line| line.chars.map(&:to_i) }
map_length = map.length
full_map_length = map.length

# The following two methods is the A* algorithm from Wikipedia: https://en.wikipedia.org/wiki/A*_search_algorithm
#
# This is a generalized implementation of A*
#
# We supply a start and goal element
#
# neighbors is a callable that takes the current element and returns its neighbors
# heuristic is a callable that takes the current element and returns its estimated cost to the goal
# weight    is a callable that takes the current and neighbor and returns the cost of traveling from the current to the neighbor
#
# We return the total cost and the path
def a_star(start:, goal:, neighbors:, heuristic:, weight:)
  # This is a priority queue that stores the entry and it's cost and gives us an ordering of the lowest cost
  open_set = PQueue.new([]) { |(entry_a, cost_a), (entry_b, cost_b)| cost_a < cost_b }

  # Stores the entry and it's cost
  open_set << [start, heuristic.call(start)]

  came_from = {}

  g_score = Hash.new { Float::INFINITY }
  g_score[start] = 0

  f_score = {}
  f_score[start] = heuristic.call(start)

  until open_set.empty?
    # Get (and remove) the element with the lowest cost. The 0th element of the returned value is the entry
    current = open_set.shift[0]
    return [f_score[current], reconstruct_path(came_from, current)] if current == goal

    neighbors.call(current).each do |neighbor|
      tentative_g_score = g_score[current] + weight.call(current, neighbor)
      if tentative_g_score < g_score[neighbor]
        neighbor_heuristic = heuristic.call(neighbor)
        came_from[neighbor] = current
        g_score[neighbor] = tentative_g_score
        f_score[neighbor] = tentative_g_score + neighbor_heuristic

        # Add the neighbor and it's cost
        open_set << [neighbor, neighbor_heuristic]
      end
    end
  end

  return []
end

# Helper method for A*
def reconstruct_path(came_from, current)
  [current].tap do |total_path|
    while came_from[current]
      current = came_from[current]
      total_path.unshift(current)
    end
  end
end

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

cost, path = a_star(start: [0,0],
                    goal: [full_map_length - 1, full_map_length - 1],
                    neighbors: neighbors,
                    heuristic: heuristic,
                    weight: weight)

ap cost

(0...full_map_length).map { |first| puts (0...full_map_length).map { |second| entry=[first,second]; path.include?(entry) ? weight.call(nil, [first,second]).to_s.yellow : weight.call(nil, [first,second]) }.join }