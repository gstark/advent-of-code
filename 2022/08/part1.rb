trees = ARGF.readlines(chomp: true).map(&:chars).map { |line| line.map(&:to_i) }

size = trees[0].length

answer = (1...size - 1).sum do |row|
  (1...size - 1).count do |col|
    me = trees[row][col]

    (0...row).all? { |r2| trees[r2][col] < me } ||
      (row + 1...size).all? { |r2| trees[r2][col] < me } ||
      (0...col).all? { |c2| trees[row][c2] < me } ||
      (col + 1...size).all? { |c2| trees[row][c2] < me }
  end
end

p answer + 4 * (size - 1)
