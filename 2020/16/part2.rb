possibilities = {}
while (line = STDIN.gets(chomp: true)) != ""
  label, low1, high1, low2, high2 = line.scan(/(.+): (\d+)-(\d+) or (\d+)-(\d+)/).first
  possibilities[label] = [low1.to_i..high1.to_i, low2.to_i..high2.to_i]
end

STDIN.gets
my_ticket = STDIN.gets(chomp: true).split(",").map(&:to_i)

STDIN.gets
STDIN.gets
valid = STDIN.readlines(chomp: true).map { |line| line.gsub(/#.*/, "").split(",").map(&:to_i) }.select do |line|
  line.all? { |value| possibilities.any? { |label, ranges| ranges.any? { |range| range.include?(value) } } }
end

columns = valid.transpose

order = []
while possibilities.any?
  index, label, size = columns.map.with_index { |column, index|
    reduction = column.map { |value| possibilities.select { |label, ranges| ranges.any? { |range| range.include?(value) } }.keys }.reduce(:&)

    [index, reduction.first, reduction.size]
  }.find { |index, label, size| size == 1 }

  order[index] = label
  possibilities.delete(label)
end

p my_ticket.each.with_index.reduce(1) { |product, (value, index)| product * (order[index].start_with?("departure") ? value : 1) }
