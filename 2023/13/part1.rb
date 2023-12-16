def mismatch_count(row1, row2)
  row1.each.with_index.count { |char, index| char != row2[index] }
end

def is_mirror(land)
  (1...land.size).find { |size| 0 == (0..size).sum { |index| (index > size * 2 - index - 1 || index <= size * 2 - land.size - 1) ? 0 : mismatch_count(land[index], land[size * 2 - index - 1]) } }
end

a = ARGF
  .read
  .split("\n\n")
  .map { |land| land.split("\n").map(&:chars) }
  .each
  .with_index
  .sum { |land, index|
    if (x = is_mirror(land))
      100 * x
    elsif (x = is_mirror(land.transpose.map(&:reverse).reverse))
      land[0].length - x
    else
      0
    end
  }
p a
