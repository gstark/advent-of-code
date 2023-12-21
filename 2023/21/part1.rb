require_relative "astar"

distance = 64
garden = ARGF.readlines(chomp: true).map(&:chars)

start_row = garden.find_index { |row| row.include?("S") }
start_col = garden[start_row].find_index { |col| col == "S" }

heuristic = proc { |(row, col)| (row - start_row).abs + (col - start_col).abs }
weight = proc { 0 }
goal = proc { |(row, col)| row == start_row && col == start_col }
neighbors = proc { |(row, col), path|
  [[0, -1], [0, 1], [-1, 0], [1, 0]]
    .map { |dr, dc| [row + dr, col + dc] }
    .select { |nr, nc| nr >= 0 && nc >= 0 && nr < garden.size && nc < garden[0].size && garden[nr][nc] != "#" }
}

total = 0
garden.size.times do |row|
  garden[0].size.times do |col|
    next unless garden[row][col] == "."
    next if (row - start_row).abs + (col - start_col).abs > distance

    result = a_star(
      start: [row, col],
      goal:,
      neighbors:,
      heuristic:,
      weight:
    )
    path = result[:path]

    steps = path.length - 1
    if steps.even?
      total += 1
    end
  end
end

p total
