passes = STDIN.read.split("\n")

def bin_search(string, range, low, high)
  string.chars.reduce(range) { |result, letter| mid = (result.max - result.min) / 2 + result.min; letter == low ? (result.min..mid) : (mid + 1..result.max) }.min
end

seats = passes.map { |pass| 8 * bin_search(pass[0..6], (0..127), "F", "B") + bin_search(pass[7..9], (0..7), "L", "R") }
min, max = seats.minmax

p (min..max).to_a - seats
