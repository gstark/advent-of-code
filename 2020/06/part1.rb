groups = STDIN.read.split("\n\n")

p groups.sum { |group| group.delete("\n").chars.uniq.length }
