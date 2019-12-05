require "set"
require "chunky_png"

input = %{R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83}

input = %{R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51\nU98,R91,D20,R16,D67,R40,U7,R15,U6,R7}

input = ARGF.read

def marks(line)
  # Return a set (since it is more efficient than an array)
  Set.new.tap do |results|
    # Start at the origin
    x, y = [0, 0]

    # Go through the line made up of pairs of directions and distances
    line.each do |direction, distance|
      case direction
      # Based on the direction, and for the number of points given by distance, mark successive points.
      when "R" then distance.times { |delta| results << [x += 1, y] }
      when "L" then distance.times { |delta| results << [x -= 1, y] }
      when "U" then distance.times { |delta| results << [x, y -= 1] }
      when "D" then distance.times { |delta| results << [x, y += 1] }
      end
    end

    # Add the final point
    results << [x, y]
  end
end

p input.
    # Break this into an array of lines
    split("\n").
    # Turn this into an array of direction and distance pairs
    map { |line| line.split(",").map { |code| [code[0], code[1..-1].to_i] } }.
    # Turn these into an array of sets of marks
    map { |line| marks(line) }.
    # Turn these into a set of marks where the mark appears in both sets.
    # This uses the intersection operator `&`
    reduce { |results, line| results & line }.
    # Turn these into the manhattan distance
    map { |x, y| x.abs + y.abs }.
    # Find the smallest one
    min
