require_relative "../../lib/grid"

grid = Grid.new(ARGF.read)

beams = [[0, grid[0].index("S")]]

count = 0
grid.height.times do |row|
  new_beams = []

  beams.each do |beam|
    if grid[beam[0] + 1, beam[1]] == "^"
      count += 1

      new_beams << [beam[0] + 1, beam[1] - 1]
      new_beams << [beam[0] + 1, beam[1] + 1]
    else
      new_beams << [beam[0] + 1, beam[1]]
    end
  end

  beams = new_beams.uniq
end

p count