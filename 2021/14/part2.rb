
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

new_pair_counts = nil

40.times do
  new_pair_counts = Hash.new { |k,v| 0 }

  template_pair_counts.each do |(left,right), count|
    lookup = pairs[left + right]

    new_pair_counts[[left,lookup]] += count
    new_pair_counts[[lookup,right]] += count
  end

  template_pair_counts = new_pair_counts
end

# We want to sum the counts when a letter is
# in the first part of our pairs
p template_pair_counts
    # Turn the template pair into a first leter and count
    .map { |(f,s), c| [f,c] }
    # Group by the first letter
    .group_by(&:first)
    # Sum up the counts
    .map { |letter, counts| [letter, counts.map(&:last).sum] }
    # Add one if the letter is the last letter in the original template
    .map { |letter, count| [letter, count + (letter == template.last ? 1 : 0) ]}
    # Take the counts
    .map(&:last)
    # Get the min and the max
    .minmax
    # Reverse them
    .reverse
    # and subtract them
    .reduce(:-)

