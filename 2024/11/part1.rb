stones = $stdin.read.split.map(&:to_i)

75.times do |i|
  p i
  stones = stones.flat_map do |stone|
    if stone == 0
      1
    elsif stone.to_s.length.even?
      stone.to_s.chars.each_slice(stone.to_s.length / 2).map(&:join).map(&:to_i)
    else
      stone * 2024
    end
  end
end

p stones.length
