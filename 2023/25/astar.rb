require "set"
require "pqueue"
require "ostruct"

# The following two methods is the A* algorithm from Wikipedia: https://en.wikipedia.org/wiki/A*_search_algorithm
#
# This is a generalized implementation of A*
#
# We supply a start and goal element
#
# neighbors is a callable that takes the current element and returns its neighbors
# heuristic is a callable that takes the current element and returns its estimated cost to the goal
# weight    is a callable that takes the current and neighbor and returns the cost of traveling from the current to the neighbor
# visit     is a callable that will receive the current node being visited
# inspector is a callable that will receive the array of `came_from` and the current node
# goal      is a callable that wihh receive the current element and return true if we've reached the goal
#
# We return the total cost and the path
def a_star(start:, goal:, neighbors:, heuristic:, weight:, inspector: proc {}, visit: proc {})
  # This is a priority queue that stores the entry and it's cost and gives us an ordering of the lowest cost
  open_set = PQueue.new([]) { |a, b| a.cost < b.cost }

  came_from = {}

  g_score = Hash.new { Float::INFINITY }
  g_score[start] = 0

  f_score = {}
  f_score[start] = heuristic.call(start)

  # Stores the entry and it's cost
  open_set << OpenStruct.new(value: start, cost: f_score[start])

  until open_set.empty?
    # Get (and remove) the element with the lowest cost. The 0th element of the returned value is the entry
    current = open_set.pop.value

    visit.call(current)

    path = reconstruct_path(came_from, current)
    inspector.call(came_from, current, path)

    if goal.call(current)
      return {score: f_score[current], path: path, visited: came_from.keys}
    end

    neighbors.call(current, path).each do |neighbor|
      tentative_g_score = g_score[current] + weight.call(current, neighbor)

      if tentative_g_score < g_score[neighbor]
        came_from[neighbor] = current
        g_score[neighbor] = tentative_g_score
        f_score[neighbor] = tentative_g_score + heuristic.call(neighbor)

        # Add the neighbor and it's cost
        open_set << OpenStruct.new(value: neighbor, cost: f_score[neighbor])
      end
    end
  end

  {score: nil, path: []}
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
