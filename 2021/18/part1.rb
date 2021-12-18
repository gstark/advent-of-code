require 'json'

class Node
  attr_reader :left
  attr_reader :right
  attr_reader :value

  def initialize(children_or_value)
    if children_or_value.kind_of?(Array)
      @left, @right = children_or_value
    else
      @value = children_or_value
    end
  end

  def node?
    !!left && !!right
  end

  def number?
    !!value
  end

  def value=(new_value)
    @value = new_value
    @left = @right = nil
  end

  def left=(new_left)
    @left = new_left
    @value = nil
  end

  def right=(new_right)
    @right = new_right
    @value = nil
  end

  def explode(prev_number, next_number)
    prev_number.value += self.left.value if prev_number
    next_number.value += self.right.value if next_number

    self.value = 0
  end

  def split
    half = self.value / 2.0

    self.left  = Node.new(half.floor.to_i)
    self.right = Node.new(half.ceil.to_i)
  end

  def magnitude
    number? ? value : 3 * left.magnitude + 2 * right.magnitude
  end
end

def parse(input)
  nodes = input.map { |child_input| child_input.kind_of?(Array) ? parse(child_input) : Node.new(child_input) }

  Node.new(nodes)
end

def walk_node(node, depth, post, yielder)
  yielder << [node, depth] unless post

  if node.node?
    walk_node(node.left, depth + 1, post, yielder)
    walk_node(node.right, depth + 1, post, yielder)
  end

  yielder << [node, depth] if post
end

def walk_tree(node, post)
  Enumerator.new do |yielder|
    walk_node(node, 0, post, yielder)
  end
end

def next_number(root, after)
  seen = false

  walk_tree(root, true).find { |(node, depth), object|
    seen = true if node == after

    break node if seen && node.number?
  }
end

def prev_number(root, before)
  last_number = nil

  walk_tree(root, false).find { |(node, depth), object|
    last_number = node if node.number?
  
    break last_number if node == before
  }
end  

def add(a,b)
  root = Node.new([a, b])

  loop do
    explode_pair, _ = walk_tree(root, true).find { |(node, depth)| node.node? && node.left.number? && node.right.number? && depth == 4 }
    splitable, _ = walk_tree(root, false).find { |(node, _)| node.number? && node.value >= 10 }

    break unless explode_pair || splitable

    if explode_pair
      explode_pair.explode(prev_number(root, explode_pair), next_number(root, explode_pair))
    else
      splitable.split
    end
  end

  root
end

inputs = $stdin.readlines(chomp: true)

root = parse(eval(inputs.shift))

p inputs.reduce(root) { |root, input| add(root, parse(JSON.parse(input))) }.magnitude
