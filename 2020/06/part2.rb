groups = STDIN.read.split("\n\n")

p groups.sum { |group| group.split("\n").map(&:chars).reduce(:&).length }
