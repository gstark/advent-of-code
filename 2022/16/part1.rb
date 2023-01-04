require_relative 'astar'
lines = ARGF.readlines(chomp: true).map { |line| line.scan(/Valve (..) has flow rate=(\d*); tunnels? leads? to valves? (.*)/).first }
valves = lines.map { |valve, rate, other| {name: valve, rate: rate.to_i, neighbors: other.split(", ")} }

distances = valves.to_h { |valve| [[valve[:name], valve[:name]], 0] }
valves.combination(2).each do |a, b|
  result = a_star(start: a[:name], goal: b[:name], neighbors: proc { |valve_name| valves.find { |valve| valve[:name] == valve_name }[:neighbors] }, heuristic: proc { |a,b| 1 }, weight: proc { |a,b| 1 }, inspector: proc {}, visit: proc {})

  distances[[a[:name], b[:name]]] = result[:path].length - 1
  distances[[b[:name], a[:name]]] = result[:path].length - 1
end

remaining = 30
loop do
  max = valves.max_by { |valve|
    distance = distances[["DD", valve[:name]]]
    rate = valves.find { |o| o[:name] == valve[:name] }[:rate]

    # p [valve[:name], (remaining - distance - 1), rate, (remaining - distance - 1) * rate * valve[:neighbors].length ]
    (remaining - distance - 1) * rate * valve[:neighbors].length
  }
  valves.find { |valve| valve[:name] == max[:name] }[:rate] = 0
  p max
end