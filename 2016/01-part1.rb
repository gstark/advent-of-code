def walk(input)
  {x: 0, y: 0}.tap do |coord|
    angle = 0

    input.
      scan(/([RL])(\d+)(, )?/).
      map { |direction, distance, _| [direction, distance.to_i ] }.
      each do |direction, distance|
        angle -= (direction == "L" ? 90 : -90)

        case angle % 360
          when 0   then coord[:y] -= distance
          when 90  then coord[:x] += distance
          when 180 then coord[:y] += distance
          when 270 then coord[:x] -= distance
        end
    end
  end.values.map(&:abs).sum
end

def walk(input)
  h = 0
  v = 0
  angle = 0

  input.
    scan(/([RL])(\d+)(, )?/).
    map { |direction, distance, _| [direction, distance.to_i ] }.
    each do |direction, distance|
      angle -= (direction == "L" ? 90 : -90)

      case angle % 360
        when 0   then v -= distance
        when 90  then h += distance
        when 180 then v += distance
        when 270 then h -= distance
      end
  end

  h.abs + v.abs
end


puts walk(STDIN.read)
