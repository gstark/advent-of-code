require_relative "../../lib/grid"

grid = Grid.new(ARGF.read)

beams = [[0, grid[0].index("S")]]

tree = {}

grid.height.times do |row|
  new_beams = []

  beams.each do |beam|
    node = [beam[0], beam[1]]
    if grid[beam[0] + 1, beam[1]] == "^"
      left = [beam[0] + 1, beam[1] - 1]
      right = [beam[0] + 1, beam[1] + 1]

      tree[node] = {left:, right:}

      new_beams << left
      new_beams << right
    else
      down = [beam[0] + 1, beam[1]]

      tree[node] = {down:}

      new_beams << down
    end
  end

  beams = new_beams.uniq
end

def dfs(cache, tree, node)
  # Return the cached value if we've seen this node before
  return cache[node] if cache[node]

  # Count 1 if we are off the tree (must have wen't past a leaf)
  return 1 if tree[node].nil?

  # If we just head downward just return the count of the downward branch
  return cache[node] ||= dfs(cache, tree, tree[node][:down]) if tree[node][:down]

  # Sum the left and right counts
  dfs(cache, tree, tree[node][:left]) + dfs(cache, tree, tree[node][:right])
end

p dfs({}, tree, tree.keys.first)

# 48021610271997
