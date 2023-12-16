grid = ARGF.readlines(chomp: true).map(&:chars)

def count(grid:, start_row:, start_col:)
  beams = [{row: start_row, col: start_col, direction: :right}]
  energized = Set.new
  beam_set = Set.new

  loop do
    beams = beams.flat_map do |beam|
      row = beam[:row]
      col = beam[:col]
      direction = beam[:direction]
      current = grid[row][col]

      next if beam_set.include?(beam)
      beam_set << beam

      energized << {row:, col:}
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
    end.compact.uniq.reject { |beam| beam[:row] < 0 || beam[:col] < 0 || beam[:row] >= grid.length || beam[:col] >= grid[0].length }

    return energized.size if beams.empty?
  end
end

p count(grid:, start_row: 0, start_col: 0)
