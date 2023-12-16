grid = ARGF.readlines(chomp: true).map(&:chars)

Beam = Data.define(:row, :col, :direction)

def count(grid:, start_row:, start_col:, start_direction:)
  beams = Set.new([Beam.new(row: start_row, col: start_col, direction: start_direction)])
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

    beams = beams.select { |beam| (0...grid.length).cover?(beam.row) && (0...grid[0].length).cover?(beam.col) }

    return energized.size if beams.empty?
  end
end

#
#
# Do need to check all the way around the grid
p [
  # left column
  *(0...grid.length).map { |start_row| count(grid:, start_row:, start_col: 0, start_direction: :right) },
  # right column
  *(0...grid.length).map { |start_row| count(grid:, start_row:, start_col: grid[0].length - 1, start_direction: :left) },
  # top row
  *(0...grid[0].length).map { |start_col| count(grid:, start_row: 0, start_col:, start_direction: :left) },
  # bottom row
  *(0...grid[0].length).map { |start_col| count(grid:, start_row: grid.length-1, start_col:, start_direction: :left) },
].max
