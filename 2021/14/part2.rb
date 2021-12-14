
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
pairs = lines
         .each
         .with_object({}) { |line, object| object.merge!(line.scan(/(\w\w) -> (\w)/).to_h) }

def enumerator_for_template(pairs, template)
  # Start with a tally of pair counts
  new_pair_counts = template.each_cons(2).tally

  Enumerator.new do |yielder|
    loop do
      # The new pair counts can be computed by
      # going through all of the existing pair counts
      # and adding 1 for the [left, lookup] pair
      # and adding 1 for the [lookup, right] pair
      # for every count of the orinal pair
      new_pair_counts = new_pair_counts.each.with_object(Hash.new {0} ) do |((left,right), count), new_pair_counts|
        lookup = pairs[left + right]

        new_pair_counts[[left,lookup]] += count
        new_pair_counts[[lookup,right]] += count
      end

      # Yield the new_pair_counts to the enumerator
      yielder << new_pair_counts
    end
  end
end

# We want to sum the counts when a letter is
# in the first part of our pairs
ap enumerator_for_template(pairs, template)
    # Run 40 iterations
    .take(40)
    # Consider the last
    .last
    # Go through each
    .each
    # For each letter/count pair, increment the count for that letter (using hash with a default value of 0)
    .with_object(Hash.new { 0 }) { |((first_letter,_), count), sums| sums[first_letter] += count }
    # Then add one if the letter is the last letter in the original template
    .map { |letter, count| [letter, count + (letter == template.last ? 1 : 0) ]}
    # Take the counts
    .map(&:last)
    # Get the min and the max
    .minmax
    # Subtract the min from the max
    .yield_self { |min, max| max - min}