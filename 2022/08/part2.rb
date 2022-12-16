trees = ARGF.readlines(chomp: true).map(&:chars).map { |line| line.map(&:to_i) }

size = trees[0].length

answer = (0...size).flat_map do |row|
  (0...size).map do |col|
    me = trees[row][col]

    # Look each direction for the first index where we have a tree our size or taller
    # Uses `then` to see if the index is present, if so we'll use one MORE than that value
    # since `find_index` is zero based. Otherwise we'll use the number of entries.
    #
    # This is cleaner than the previous hackery seen in the last commit.
    [
      (row - 1).downto(0).find_index { |r2| trees[r2][col] >= me }.then { |index| index ? index + 1 : row },
      (col - 1).downto(0).find_index { |c2| trees[row][c2] >= me }.then { |index| index ? index + 1 : col },
      (col + 1...size).find_index { |c2| trees[row][c2] >= me }.then { |index| index ? index + 1 : size - col - 1 },
      (row + 1...size).find_index { |r2| trees[r2][col] >= me }.then { |index| index ? index + 1 : size - row - 1 }
    ].reduce(&:*)
  end
end

p answer.max
