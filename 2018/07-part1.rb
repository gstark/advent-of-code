lines = File.readlines("07-input.txt")

map = {}

lines.each do |line|
  left, right = line.chomp.split(" -> ")

  parent, size = left.gsub(/[()]/, "").split

  map[parent] = nil unless map.key?(parent)

  next unless right

  children = right.split(", ")

  children.each do |child|
    map[child] = parent
  end
end

p map.find { |child, parent| parent.nil? }
