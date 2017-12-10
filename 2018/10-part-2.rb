list = (0..255).to_a
original_input = File.read("10-input.txt").chars.map(&:ord) + [17, 31, 73, 47, 23]

# list = [0,1,2,3,4]
# input = [3,4,1,5]

skip = 0
position = 0

64.times do
  input = original_input.dup

  input.each do |length|
    next if length > list.length

    start_pos = position
    end_pos   = (position + length - 1) % list.length

    (length/2).times do
      list[start_pos], list[end_pos] = [list[end_pos], list[start_pos]]

      start_pos = (start_pos + 1) % list.length
      end_pos   = (end_pos - 1) % list.length
    end

    position = (position + length + skip) % list.length
    skip += 1
  end
end

p list.each_slice(16).map { |block| block.inject(&:^) }.map { |x| x.to_s(16) }.join
