require 'awesome_print'

map = $stdin.readlines.map { |line| line.chars.map(&:to_i) }

# The following two methods is the A* algorithm from Wikipedia: https://en.wikipedia.org/wiki/A*_search_algorithm
def reconstruct_path(came_from, current)
  [current].tap do |total_path|
    while came_from[current]
      current = came_from[current]
      total_path.unshift(current)
    end
  end
end

def a_star(map, start, goal, h)
  open_set = [start]

  came_from = {}

  g_score = Hash.new { Float::INFINITY }
  g_score[start] = 0

  f_score = Hash.new { Float::INFINITY }
  f_score[start] = h.call(start)

  until open_set.empty?
    current = open_set.min_by { |entry| f_score[entry] }
    return reconstruct_path(came_from, current) if current == goal

    open_set.delete(current)
    neighbors = [
                  [current[0]+1,current[1]],
                  [current[0],current[1]+1],
                ].select { |(r,c)| r < map.length && c < map.length}

    neighbors.each do |neighbor|
      tentative_g_score = g_score[current] + map[neighbor[0]][neighbor[1]]
      if tentative_g_score < g_score[neighbor]
        came_from[neighbor] = current
        g_score[neighbor] = tentative_g_score
        f_score[neighbor] = tentative_g_score + h.call(neighbor)
        open_set << neighbor unless open_set.include?(neighbor)
      end
    end
  end

  return []
end

h = proc { |(x1,y1)| 42 } # Math.sqrt((x1-map.length)**2 + (y1-map.length)**2) }
path = a_star(map, [0,0], [map.length-1,map.length-1], h )

ap path.map { |(r,c)| map[r][c] }.sum - map[0][0]