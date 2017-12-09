require 'awesome_print'

lines = File.readlines("07-input.txt")

#lines = %{ pbga (66)
#xhth (57)
#ebii (61)
#havc (66)
#ktlj (57)
#fwft (72) -> ktlj, cntj, xhth
#qoyq (66)
#padx (45) -> pbga, havc, qoyq
#tknk (41) -> ugml, padx, fwft
#jptl (61)
#ugml (68) -> gyxo, ebii, jptl
#gyxo (61)
#cntj (57)}.split("\n")

map = {}
@weights = {}

lines.each do |line|
  left, right = line.chomp.split(" -> ")

  parent, weight = left.gsub(/[()]/, "").split

  @weights[parent] = weight.to_i

  map[parent] = nil unless map.key?(parent)

  next unless right

  children = right.split(", ")

  children.each do |child|
    map[child] = parent
  end
end

root, _ = map.find { |child, parent| parent.nil? }

@new_map = {}
map.each do |child, parent|
  next if parent.nil?

  if @new_map.key?(parent)
    @new_map[parent] << child
  else
    @new_map[parent] = [child]
  end
end

def weight(key)
  key_weight = @weights[key]

  if @new_map[key].nil? || @new_map[key].empty?
    return key_weight
  else
    @new_map[key].map { |child| weight(child) }.sum + key_weight
  end
end

def traverse(key)
  children = @new_map[key]
  children_weights = children.map { |child| [child, weight(child)] }.to_h

  a, b, c = children_weights.values

  same = case
         when a == b then a
         when b == c then b
         when a == c then a
         end

  wrong_key, wrong_weight = children_weights.find { |child, weight| weight != same }

  if @new_map[wrong_key].map { |child| weight(child) }.uniq.size == 1
    @weights[wrong_key] - (wrong_weight - same)
  else
    traverse(wrong_key)
  end
end

p traverse(root)
