# https://github.com/patchfx/astar

$map = $stdin.readlines.map { |line| line.chars.map(&:to_i) }

class Tile
  attr_reader :x, :y

  # returns the surrounding tiles that are walkable
  def walkable_neighbours
    [
      [x+1,y]
      [x,y+1],
    ].select { |(x,y)| x < $map.length && y < $map.length}
  end
end

