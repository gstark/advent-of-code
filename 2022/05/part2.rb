require "awesome_print"

raw_stacks, raw_instructions = ARGF.readlines(chomp: true).slice_before(&:empty?).to_a

stacks = raw_stacks
  # Give me the lines as characters
  .map(&:chars)
  # But transpose them so rows are columns and columns are rows
  .transpose
  # Only take the lines that have a number in them, eveything else is filler
  .select { |line| line.last.match?(/[1-9]/) }
  # Then only keep the elements that are A-Z
  .map { |line| line & ("A".."Z").to_a }

raw_instructions
  .reject(&:empty?)
  .map { |line| line.scan(/move (\d+) from (\d+) to (\d+)/).first }
  .map { |line| line.map(&:to_i) }
  .each { |(count, from, to)| stacks[to - 1].unshift(*stacks[from - 1].shift(count)) }

puts stacks.map(&:first).join
