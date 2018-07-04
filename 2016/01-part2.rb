require 'set'

def walk(input)
  visited = Set.new

  coord = {x: 0, y: 0}
  visited << coord.dup

  angle = 0

  input.
    scan(/([RL])(\d+)(, )?/).
    map { |direction, distance, _| [direction, distance.to_i ] }.
    each do |direction, distance|
      angle -= (direction == "L" ? 90 : -90)

      step = case angle % 360
      when 0   then proc { |coord| coord[:y] -= 1 }
      when 90  then proc { |coord| coord[:x] += 1 }
      when 180 then proc { |coord| coord[:y] += 1 }
      when 270 then proc { |coord| coord[:x] -= 1 }
      end

      distance.times do
        step.call(coord)

        return coord.values.map(&:abs).sum if visited.include?(coord)
        visited << coord.dup
      end
  end
end

p walk(STDIN.read)
