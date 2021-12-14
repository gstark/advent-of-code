
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

template_pair_counts = template.each_cons(2).tally

char_counts = nil
new_pair_counts = nil
40.times do
  char_counts = Hash.new { |k,v| 0}
  new_pair_counts = Hash.new { |k,v| 0 }

  template_pair_counts.each do |(left,right), count|
    lookup = pairs[left + right]

    new_pair_counts[[left,lookup]] += count
    new_pair_counts[[lookup,right]] += count

    char_counts[left] += count
    char_counts[lookup] += count
  end

  char_counts[template.last] += 1

  template_pair_counts = new_pair_counts
end

ap char_counts.values.minmax.reverse.reduce(&:-)

