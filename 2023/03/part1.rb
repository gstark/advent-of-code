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

p STDIN
  .readlines(chomp: true)
  .yield_self { |lines|
    {
      # Hash of start position of all the numbers [row,col] => number
      #
      # We do this by looking at pairs of characters from each line.
      # If the character is a digit and is at the start of the row we take the coord as [row, 0] and extract the number at that offset
      # otherwise if the SECOND char is a digit and the FIRST is not, we are starting a number, take the coord as [row, col+1] at that offset
      numbers: lines.flat_map.with_index { |line, row| line.chars.each_cons(2).map.with_index { |(a,b), col| ((col == 0 && a.between?('0', '9')) ? [[row, col], line[col..].to_i] : nil) || (b.between?('0', '9') && !a.between?('0', '9') ? [[row, col+1], line[col+1..].to_i] : nil) }.compact }.to_h,

      # Hash of position of all the symbols [row, col] => character
      symbols: lines.flat_map.with_index { |line, row| line.chars.map.with_index { |char, col| %[.0123456789].include?(char) ? nil : [[row, col], char] } }.compact.to_h
    }
  }
  .yield_self { |data|
    {
      # Just the symbols
      symbols: data[:symbols],

      # Expand the hash to include an entry for every position within the number itself
      # [row, col] => [number, starting_coord]
      numbers: data[:numbers].flat_map { |starting_coord, number| number.digits.map.with_index { |_digit, index| [[starting_coord[0], starting_coord[1] + index], [number, starting_coord]] } }.to_h
    }
  }
  # Go through all the symbols looking for a number that is a neighbor
  .yield_self { |data|
    data[:symbols].flat_map { |position, char| NEIGHBORS.map { |dx, dy| data[:numbers][[position[0] + dx, position[1] + dy]] } }
  }
  # Remove any nil (non matches)
  .yield_self { |numbers| numbers.compact }
  # Take only the unique number matches
  .yield_self { |numbers| numbers.uniq }
  # The number is the first part of the tuple
  .map(&:first)
  # Sum!
  .sum


