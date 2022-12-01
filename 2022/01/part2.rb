input = File.readlines("input.txt", chomp: true).map(&:to_i)

p input.chunk_while { |i, j| !j.zero? }.map(&:sum).sort.last(3).sum
