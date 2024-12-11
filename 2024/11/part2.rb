stones = $stdin.read.split.map(&:to_i)

CACHE = {}

def stone_length(stone, depth = 0)
  return 1 if depth == 75

  CACHE[[stone, depth]] ||= if stone == 0
    stone_length(1, depth + 1)
  elsif (stone_string = stone.to_s).length.even?
    stone_length(stone_string[0...stone_string.length / 2].to_i, depth + 1) +
      stone_length(stone_string[stone_string.length / 2..].to_i, depth + 1)
  else
    stone_length(stone * 2024, depth + 1)
  end
end

p stones.sum { |stone| stone_length(stone) }
