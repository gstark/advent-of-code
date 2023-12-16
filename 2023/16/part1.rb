grid = ARGF.readlines(chomp: true).map(&:chars)

beams = [
  {row: 0, col: 0, direction: :right}
]

energized = {}
seen = {beams: 1, energized: 0}

answer = loop do
  beams = beams.flat_map do |beam|
    row = beam[:row]
    col = beam[:col]
    direction = beam[:direction]
    current = grid[row][col]

    energized[{row:, col:}] = true
    case current
    when "."
      case beam[:direction]
      when :right then {row:, col: col + 1, direction:}
      when :left then {row:, col: col - 1, direction:}
      when :up then {row: row - 1, col:, direction:}
      when :down then {row: row + 1, col:, direction:}
      end
    when "|"
      [
        {row: row - 1, col:, direction: :up},
        {row: row + 1, col:, direction: :down}
      ]
    when "-"
      [
        {row:, col: col - 1, direction: :left},
        {row:, col: col + 1, direction: :right}
      ]
    when "/"
      case direction
      when :right then {row: row - 1, col:, direction: :up}
      when :left then {row: row + 1, col:, direction: :down}
      when :up then {row:, col: col + 1, direction: :right}
      when :down then {row:, col: col - 1, direction: :left}
      end
    when "\\"
      case direction
      when :right then {row: row + 1, col:, direction: :down}
      when :left then {row: row - 1, col:, direction: :up}
      when :up then {row:, col: col - 1, direction: :left}
      when :down then {row:, col: col + 1, direction: :right}
      end
    end
  end.uniq.reject { |beam| beam[:row] < 0 || beam[:col] < 0 || beam[:row] >= grid.length || beam[:col] >= grid[0].length }

  # (0...grid.length).each do |row|
  #   (0...grid[0].length).each do |col|
  #     print energized[{row:, col:}] ? "#" : grid[row][col]
  #   end
  #   puts
  # end
  if seen.key?({beams:, energized:})
    break energized.size
  end

  seen[{beams:, energized:}] = true
end

p answer
