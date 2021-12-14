
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
  pair_counts = template.each_cons(2).tally

  Enumerator.new do |yielder|
    loop do
      new_pair_counts = Hash.new { |k,v| 0 }

      pair_counts.each do |(left,right), count|
        lookup = pairs[left + right]

        new_pair_counts[[left,lookup]] += count
        new_pair_counts[[lookup,right]] += count
      end

      yielder << new_pair_counts

      pair_counts = new_pair_counts
    end
  end
end

# We want to sum the counts when a letter is
# in the first part of our pairs
ap enumerator_for_template(pairs, template)
    # Run 40 iterations
    .take(10)
    # Consider the last
    .last
    # Group the information by first letter
    .group_by { |(first_letter, second_letter), count| first_letter }
    # For each first letter, we sum up the counts, which are now the last element in the grouping
    .map { |first_letter, counts| [first_letter, counts.sum(&:last)] }
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
