require 'awesome_print'

map = $stdin.readlines.map { |line| line.chars.map(&:to_i) }

# The following two methods is the A* algorithm from Wikipedia: https://en.wikipedia.org/wiki/A*_search_algorithm
#
# This is a generalized implementation of A*
#
# We supply a start and goal element
#
# neighbors is a callable that takes the current element and returns its neighbors
# heuristic is a callable that takes the current element and returns its estimated cost to the goal
# weight    is a callable that takes the current and neighbor and returns the cost of traveling from the current to the neighbor
def a_star(start:, goal:, neighbors:, heuristic:, weight:)
  open_set = [start]

  came_from = {}

  g_score = Hash.new { Float::INFINITY }
  g_score[start] = 0

  f_score = Hash.new { Float::INFINITY }
  f_score[start] = heuristic.call(start)

  until open_set.empty?
    current = open_set.min_by { |entry| f_score[entry] }
    return reconstruct_path(came_from, current) if current == goal

    open_set.delete(current)

    neighbors.call(current).each do |neighbor|
      tentative_g_score = g_score[current] + weight.call(current, neighbor)
      if tentative_g_score < g_score[neighbor]
        came_from[neighbor] = current
        g_score[neighbor] = tentative_g_score
        f_score[neighbor] = tentative_g_score + heuristic.call(neighbor)
        open_set << neighbor unless open_set.include?(neighbor)
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
heuristic = proc { |current| Math.sqrt((current[0] - map.length)**2 + (current[1] - map.length)**2) }

# This is the weight of traveling from current to the neighbor, in this case it is just the weight of the neighbor
weight    = proc { |current, neighbor| map[neighbor[0]][neighbor[1]] }

# Returns the possible neighbors of the current element
neighbors = proc { |current| neighbors = [[current[0]+1,current[1]], [current[0],current[1]+1]].select { |(r,c)| r < map.length && c < map.length } }

path = a_star(start: [0,0],
              goal: [map.length-1,map.length-1],
              neighbors: neighbors,
              heuristic: heuristic,
              weight: weight)

ap path.map { |(r,c)| map[r][c] }.sum - map[0][0]