list = (0..255).to_a
input = File.read("10-input.txt").split(",").map(&:to_i)

# list = [0,1,2,3,4]
# input = [3,4,1,5]

skip = 0
position = 0

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

p list

p list[0] * list[1]
