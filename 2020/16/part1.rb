possibilities = {}
while (line = STDIN.gets(chomp: true)) != ""
  label, low1, high1, low2, high2 = line.scan(/(\w+): (\d+)-(\d+) or (\d+)-(\d+)/).first
  possibilities[label] = [low1.to_i..high1.to_i, low2.to_i..high2.to_i]
end

STDIN.gets
my_ticket = STDIN.gets(chomp: true)

STDIN.gets
answer = STDIN.readlines(chomp: true).sum do |line|
  line.split(",").map(&:to_i).sum { |value| possibilities.any? { |label, ranges| ranges.any? { |range| range.include?(value) } } ? 0 : value }
end

p answer
