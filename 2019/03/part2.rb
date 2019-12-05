require "set"
require "chunky_png"

input = %{R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83}

input = %{R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51\nU98,R91,D20,R16,D67,R40,U7,R15,U6,R7}

input = ARGF.read

# Define a mark class that contains the X,Y coordinate and the current step count
#
# However, compare and hash the value based only on the coordinates. This way, when
# we set-intersect we'll still compare on X,Y coordinates only
class Mark
  attr_accessor :x, :y, :step

  def initialize(x:, y:, step:)
    self.x = x
    self.y = y
    self.step = step
  end

  def hash
    [x, y].hash
  end

  def eql?(other)
    other.x == self.x && other.y == self.y
  end
end

def marks(line)
  # Keep track of steps
  step = 0
  Set.new.tap do |results|
    x, y = [0, 0]
    line.each do |direction, distance|
      case direction
      # Instead of keeping track of simple [x,y] pairs, create Mark object
      when "R" then distance.times { |delta| results << Mark.new(x: x += 1, y: y, step: step += 1) }
      when "L" then distance.times { |delta| results << Mark.new(x: x -= 1, y: y, step: step += 1) }
      when "U" then distance.times { |delta| results << Mark.new(x: x, y: y -= 1, step: step += 1) }
      when "D" then distance.times { |delta| results << Mark.new(x: x, y: y += 1, step: step += 1) }
      end
    end
    results << Mark.new(x: x, y: y, step: step += 1)
  end
end

# Turn the input into sets of marks
marks = input.
  split("\n").
  map { |line| line.split(",").map { |code| [code[0], code[1..-1].to_i] } }.
  map { |line| marks(line) }

p marks.
    # generate an array of marks that appear in both sets
    reduce { |results, line| results & line }.
    # Turn this into an array of distances by taking each mark
    # and looking into each set, adding together the step counter
    map { |mark| marks[0].find { |m| m.eql?(mark) }.step + marks[1].find { |m| m.eql?(mark) }.step }.
    # Find the minimum
    min
