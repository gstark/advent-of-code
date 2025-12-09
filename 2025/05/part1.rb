ranges, ingredients = $stdin.read.split("\n\n")

ranges = ranges.split("\n").map { |range| Range.new(*range.split("-").map(&:to_i)) }
ingredients = ingredients.split("\n").map(&:to_i)

p ingredients.count { |ingredient| ranges.any? { |range| range.cover?(ingredient) } }