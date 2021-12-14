require 'awesome_print'

lines = $stdin.readlines(chomp: true)

# The template is the first line
template = lines.shift.chars

# Skip the second line
lines.shift

# Generate a hash of pairs
#
# like:
#
# {
#   "CH" => "B",
#   "HH" => "N",
#   "CB" => "H",
#   ...
# }
pairs = lines.each.with_object({}) { |line, object| object.merge!(line.scan(/(\w\w) -> (\w)/).to_h) }

# 10 times
#
# Go through the template each consecutive two elements
# make a new element that is the left part of the pair
# followed by the inserted element.
# 
# The second half of the element will be the *first* part
# of the next pair.
#
# for instance if we had the template ABCD, and if the
# pairs are:  AB => 1, BC => 2, CD => 3
#
# (A,B) => left, right => [left, pairs[left+right]] => [A, 1]
# (B,C) => left, right => [left, pairs[left+right]] => [B, 2]
# (C,D) => left, right => [left, pairs[left+right]] => [C, 3]
#
# Then we need to add in the trailing last character: "D"
#
# Use flat map to end up with a single array of [A,1,B,2,C,3,D]

10.times { template = template.each_cons(2).flat_map { |left, right| [left, pairs[left + right]] } + [template.last] }

ap template.tally.values.minmax.reverse.inject(&:-)

