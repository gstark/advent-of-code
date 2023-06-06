require_relative 'astar'

lines = ARGF.readlines(chomp: true).map { |line| line.scan(/Valve (..) has flow rate=(\d*); tunnels? leads? to valves? (.*)/).first }
valves = lines.map { |valve, rate, other| {name: valve, rate: rate.to_i, neighbors: other.split(", ")} }

@distances = {}
valves.select { |valve| valve[:name] == "AA" || valve[:rate] > 0 }.combination(2).each do |a, b|
  next if a[:name] == b[:name]

  result = a_star(start: a[:name], goal: b[:name], neighbors: proc { |valve_name| valves.find { |valve| valve[:name] == valve_name }[:neighbors] }, heuristic: proc { |a,b| 1 }, weight: proc { |a,b| 1 }, inspector: proc {}, visit: proc {})

  @distances[[a[:name], b[:name]]] = result[:path].length - 1
  @distances[[b[:name], a[:name]]] = result[:path].length - 1
end

@valve_rates = valves.to_h { |valve| [valve[:name], valve[:rate]] }

def dfs(current, flow_so_far, time_remaining, visited)
  visited << current

  max_flow = flow_so_far
  neighbors = @distances.select { |(from, _to)| from == current }
  neighbors.each do |(pair, distance)|
    _from, to = pair

    new_time_remaining = time_remaining - distance - 1

    next if visited.include?(to) || new_time_remaining <= 0

    new_flow = flow_so_far + @valve_rates[to] * (time_remaining - distance - 1) 

    max_flow = [max_flow, dfs(to, new_flow, new_time_remaining, visited.dup)].max
  end

  max_flow
end

p dfs("AA", 0, 30, Set.new)
