grid = ARGF.readlines(chomp: true).map(&:chars)

Beam = Data.define(:row, :col, :direction)

def count(grid:, start_row:, start_col:)
  beams = Set.new([Beam.new(row: start_row, col: start_col, direction: :right)])
  energized = Set.new
  seen_beams = Set.new

  loop do
    beams = beams.reject { |beam| seen_beams.include?(beam) }

    beams = beams.flat_map do |beam|
      row, col, direction = beam.deconstruct

      seen_beams << beam

      energized << {row:, col:}
      case grid[row][col]
      when "."
        case direction
        when :right then beam.with(col: col + 1)
        when :left then beam.with(col: col - 1)
        when :up then beam.with(row: row - 1)
        when :down then beam.with(row: row + 1)
        end
      when "|"
        [beam.with(row: row - 1, direction: :up), beam.with(row: row + 1, direction: :down)]
      when "-"
        [beam.with(col: col - 1, direction: :left), beam.with(col: col + 1, direction: :right)]
      when "/"
        case direction
        when :right then beam.with(row: row - 1, direction: :up)
        when :left then beam.with(row: row + 1, direction: :down)
        when :up then beam.with(col: col + 1, direction: :right)
        when :down then beam.with(col: col - 1, direction: :left)
        end
      when "\\"
        case direction
        when :right then beam.with(row: row + 1, direction: :down)
        when :left then beam.with(row: row - 1, direction: :up)
        when :up then beam.with(col: col - 1, direction: :left)
        when :down then beam.with(col: col + 1, direction: :right)
        end
      end
    end

    beams = beams.select { |beam| (0...grid.length).include?(beam.row) && (0...grid[0].length).include?(beam.col) }

    return energized.size if beams.empty?
  end
end

p count(grid:, start_row: 0, start_col: 0)
