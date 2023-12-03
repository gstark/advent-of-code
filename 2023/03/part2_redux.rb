#
# While this is still some wild and crazy code
# it represents, IMHO, a slightly cleaner approach
# to my original attempt.
#
# I've given up the "one liner" to make this a bit
# cleaner to read.
#

NEIGHBORS = [
  [-1,-1],
  [-1,+0],
  [-1,+1],

  [+0, -1],
  [+0, +1],

  [+1,-1],
  [+1,+0],
  [+1,+1],
]

lines = STDIN.readlines(chomp: true)

symbols = lines
  # Build an array of tuples. The first part of the tuple is itself a row/col tuple, and the second part is the character
  .flat_map.with_index { |line, row| line.chars.map.with_index { |char, col| [{row: row, col: col}, char] } }
  # Then reject anything that isn't a symbol
  .reject { |_, char| %[.0123456789].include?(char) }

numbers = lines
  # Build up an array of the row number, the match of where an integer is, and the range of columns where the integer is.
  .flat_map.with_index { |line, row| line.enum_for(:scan, /\d+/).map { |number| [row, number.to_i, Regexp.last_match.begin(0)...Regexp.last_match.end(0)] } }
  # Turn that into an array of the row, column, number, and a uniqueness slug
  # We need the uniqueness slug in case the same number exists as a neighbor twice.
  #
  # For instance:
  #
  # ......35*35....
  #
  # This would have `35` in the result twice, but with a different uniqueness slug.
  # We will use the hash of the row and the columns range to be the slug
  #
  .flat_map { |row, number, columns| columns.map { |col| [row, col, number, [row, columns].hash] } }
  # Then turn this into a hash of the row/col coordinate => the number and a uniqueness slug
  .to_h { |row, col, number, unique_slug| [{row: row, col: col}, {number: number, unique_slug: unique_slug}] }

# For the sample this looks like:
# symbols = [[{:row=>1, :col=>3}, "*"], [{:row=>3, :col=>6}, "#"], [{:row=>4, :col=>3}, "*"], [{:row=>5, :col=>5}, "+"], ...
# numbers = {{:row=>0, :col=>0}=>{:number=>467, :unique_slug=>3985331128119852771}, {:row=>0, :col=>1}=>{:number=>467, :unique_slug=>3985331128119852771}, {:row=>0, :col=>2}=>{:number=>467, :unique_slug=>3985331128119852771}, {:row=>0, :col=>5}=>{:number=>114, :unique_slug=>-1082143951892392066}, {:row=>0, :col=>6}=>{:number=>114, :unique_slug=>-1082143951892392066}, {:row=>0, :col=>7}=>{:number=>114, :unique_slug=>-1082143951892392066}, {:row=>2, :col=>2}=>{:number=>35, :unique_slug=>2696521420617643430},

p symbols
  # For each symbol, map to all of the found, unique neighbors.
  # Repeated matches for the same "number" in `numbers` will have the exact same value
  # due to the uniqueness slug.
  .map { |position, char| NEIGHBORS.map { |dx, dy| numbers[{row: position[:row] + dx, col: position[:col] + dy}] }.compact.uniq }
  # Only take the results with two neighbors (the gears)
  .select { |neighbors| neighbors.length == 2 }
  # Take the first part which are the numbers
  .map { |neighbors| neighbors.map { |neighbor| neighbor[:number] } }
  # Multiply these together
  .map { |numbers| numbers.reduce(:*) }
  # And sum them
  .sum
