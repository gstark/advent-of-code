require "set"

jolts = Set.new(STDIN.readlines.map(&:to_i).sort)

max_jolts = jolts.max
jolts << max_jolts + 3

def count_paths(jolts, cache, from)
  cache[from] ||= (1..3).sum { |diff| jolts.include?(from + diff) ? count_paths(jolts, cache, from + diff) : 0 }
end

p count_paths(jolts, { max_jolts => 1 }, 0)
