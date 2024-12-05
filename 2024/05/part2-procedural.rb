# This is a more procedural version of part2.rb
rules = []
updates = []

# Read the rules up until the first blank line
loop do
  line = $stdin.readline(chomp: true)
  break if line == ""

  rules << line.split("|").map(&:to_i)
end

# The updates are the rest of the input
loop do
  updates << $stdin.readline(chomp: true).split(",").map(&:to_i)
  break if $stdin.eof?
end

# Sort the rules by the first page
rules.sort_by! { |a, _| a }

# Remove all updates that are valid
updates.reject! { |update| update.all? { |page| rules.filter { |a, _| a == page }.all? { |a, b| !update.include?(b) || update.index(a) < update.index(b) } } }

# Transform the updates to be in the correct order
updates.map! { |update|
  # Take the current update and yield a copy to be returned by the block
  update.tap { |new_update|
    # Loop through each rule
    rules.each { |a, b|
      # Find if we have each page in the update
      ai = new_update.index(a)
      bi = new_update.index(b)

      # If we do, and they are in the wrong order,
      # then move the later page before the earlier page
      if ai && bi && ai > bi
        new_update.delete_at(ai)
        new_update.insert(bi, a)
      end
    }
  }
}

# Print out the sum of the middle pages
p updates.sum { |update| update[update.length / 2] }
