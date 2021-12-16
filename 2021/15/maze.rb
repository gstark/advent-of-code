require 'awesome_print'
require 'ruby2d'
require_relative "./astar"

maze = `./amaze 69 69 .`.split("\n").map(&:chars).reject(&:empty?)

start = [0, maze.first.index(' ')]
goal = [maze.length - 1, maze.last.index(' ')]

set resizable: true, width: 1024, height: 1024, title: 'A* maze'

heuristic = proc { |current| (goal[0] - current[0])** 2 + (goal[1] - current[1])**2}
weight = proc { |current, neighbor| 0 }
neighbors = proc { |(r,c)| [[r+1,c], [r-1,c], [r,c+1], [r,c-1]].select { |(r,c)| r >= 0 && r < maze.length && c >= 0 && c < maze[0].length }.select { |r,c| maze[r][c] == ' ' } }

Thread.new do
  current_square = Square.new(x: start[1]*5, y: start[0]*5, size: 5, color: 'yellow', z: 1)
  maze.each.with_index do |row, r|
    row.each.with_index do |col, c|
      Square.new(x: c*5, y: r*5, size: 5, color: 'blue') if col == '.'
    end
  end
  goal_square = Square.new(x: goal[1]*5, y: goal[0]*5, size: 5, color: 'red', z: 2)

  visit = proc do |visited|
    Square.new(x: visited[1]*5, y: visited[0]*5, size: 5, color: 'green')
  end

  inspector = proc do |visited, current|
    current_square.y = current[0]*5
    current_square.x = current[1]*5
  end
  
  a_star(start: start,
         goal: goal,
         neighbors: neighbors,
         heuristic: heuristic,
         weight: weight,
         inspector: inspector,
         visit: visit)
end

show