first_seen = {}
last_seen = {}

input = [0, 1, 5, 10, 3, 12, 19]

input.each.with_index { |say, index| last_seen[say] = index + 1 }

answer = (input.length + 1..30000000).reduce(input.last) do |last_number, turn|
  (first_seen[last_number] ? last_seen[last_number] - first_seen[last_number] : 0).tap do |say|
    first_seen[say] = last_seen[say]
    last_seen[say] = turn
  end
end

p first_seen.keys.size
p answer
