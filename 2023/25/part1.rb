require_relative "astar"

# This is a solution based on frequency/probability
#
# We will do 1000 samplings of finding the shortest
# route between two random nodes in our graph. For
# each shortest path we'll count how often we traversed
# all the edges in the path. We _hope_ that the most
# frequent three edges become clear as they should be
# the ones that connect our two distinct sub graphs.
#
# If the number of samples doesn't work we'd have to
# increase this or find a new algorithm.
#
# Once we have the edges, we will remove them from the
# graph. We'll pick a random starting node and then try
# to find the shortest path to each other node in the
# system. If we find a path we are in that node's graph
# otherwise we are in the other one. We'll just count
# these up.

# Build up a graph of connections
connections = {}
ARGF.readlines(chomp: true).each do |line|
  source, destinations = line.split(":")
  destinations = destinations.split
  destinations.each do |destination|
    connections[source] ||= []
    connections[destination] ||= []

    connections[source] << destination
    connections[destination] << source
  end
end

# Keep a hash of the number of times we've seen an edge
edge_counts = {}
1000.times do |index|
  puts "Finding random paths through the graph #{index}/1000"

  # Start and end at random nodes
  start_node = connections.keys.sample
  end_node = (connections.keys - [start_node]).sample

  # Find the shortest path
  result = a_star(
    start: start_node,
    goal: proc { |node| node == end_node },
    neighbors: proc { |node| connections[node] },
    heuristic: proc { 0 },
    weight: proc { 0 }
  )

  # For each edge, increment the seen edge count
  result[:path].each_cons(2) do |from, to|
    edge_counts[[from, to].sort] ||= 0
    edge_counts[[from, to].sort] += 1
  end
end

# Find the three most commonly traversed edge
edges = edge_counts.sort_by { |k, v| v }.to_h.keys.last(3)

# Remove them from the connections
edges.each do |from, to|
  connections[from] = connections[from] - [to]
  connections[to] = connections[to] - [from]
end

# Start from the first node (could be any node)
from = connections.keys.first

# go through all the other nodes and partition
# them into two groups. The first group is *NOT*
# connected to our "from" node (e.g. the score is nil)
# and the other group *IS* connected
group_a, group_b = connections.keys.partition do |to|
  puts "Seeing if we can connect #{from} and #{to}"

  # Attempt to find a path from our consistent
  # starting node to each of the other nodes
  result = a_star(
    start: from,
    goal: proc { |node| node == to },
    neighbors: proc { |node| connections[node] },
    heuristic: proc { 0 },
    weight: proc { 0 }
  )

  # If we found a connection (have a score) then
  # we are in the same graph as the starting node
  # otherwise we are in the other
  result[:score].nil?
end

# The answer is the product of the lengths of the graphs
p group_a.length * group_b.length
