forrest = STDIN.read.split("\n").map { |line| line.chars }

def count_forrest(forrest, delta_offset, delta_row)
  offset = delta_offset
  row = delta_row
  count = 0
  while row < forrest.length
    count += 1 if forrest[row][offset] == "#"
    row += delta_row
    offset = (offset + delta_offset) % forrest.first.length
  end

  return count
end

p [
  count_forrest(forrest, 1, 1),
  count_forrest(forrest, 3, 1),
  count_forrest(forrest, 5, 1),
  count_forrest(forrest, 7, 1),
  count_forrest(forrest, 1, 2),
].reduce(:*)
