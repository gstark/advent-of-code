trees = ARGF.readlines(chomp: true).map(&:chars).map { |line| line.map(&:to_i) }

size = trees[0].length

answer = (0...size).flat_map do |row|
  (0...size).map do |col|
    me = trees[row][col]

    # Look each direction for the first index where we have a tree our size or taller
    # since find index is 0 based we'll add one to the result. However, if we DON'T find
    # anything find_index returns nil so we need to return one LESS than the size so we
    # get the correct value when we add one. Curious if there is a way to avoid this +1 / -1
    # magic.
    [
      ((row - 1).downto(0).find_index { |r2| trees[r2][col] >= me } || row - 1) + 1,
      ((col - 1).downto(0).find_index { |c2| trees[row][c2] >= me } || col - 1) + 1,
      ((col + 1...size).find_index { |c2| trees[row][c2] >= me } || size - col - 2) + 1,
      ((row + 1...size).find_index { |r2| trees[r2][col] >= me } || size - row - 2) + 1
    ].reduce(&:*)
  end
end

p answer.max
