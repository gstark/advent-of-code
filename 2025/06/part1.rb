lines = $stdin.readlines(chomp: true)

worksheet = lines
  .map { |line| line.split(" ") }
  .transpose
  .map { |row| [*row[..-2].map(&:to_i), row.last] }
  .map { |row| row[..-2].inject(row.last.to_sym) }
  .sum

p worksheet
