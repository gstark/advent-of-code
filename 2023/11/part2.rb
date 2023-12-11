space = $stdin
  .readlines(chomp: true)
  .map(&:chars)

width = space[0].length
height = space.length

double_cols = width.times.map { |col| (height.times.all? { |row| space[row][col] == "." }) ? col : nil }.compact
double_rows = height.times.map { |row| (space[row].all? { |spot| spot == "." }) ? row : nil }.compact

galaxies = []
height.times.each do |row|
  width.times.each do |col|
    galaxies << [row, col] if space[row][col] == "#"
  end
end

expansion = 1_000_000 - 1
p galaxies.permutation(2).map(&:sort).uniq.sum { |g1, g2| (g1[0] - g2[0]).abs + (g1[1] - g2[1]).abs + expansion * double_rows.count { |row| Range.new(*[g1[0], g2[0]].sort).include?(row) } + expansion * double_cols.count { |col| Range.new(*[g1[1], g2[1]].sort).include?(col) } }
