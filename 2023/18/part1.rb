plan = ARGF.readlines(chomp: true).map(&:split).map { |direction, length, color| [direction, length.to_i, color] }

map = {}
row = 0
col = 0
max_row = 0
max_col = 0
min_row = 1_000_000_000
min_col = 1_000_000_000
map[{row:, col:}] = "#"

plan.each.each do |direction, length, color|
  case direction
  when "L" then length.times { map[{row:, col: col -= 1}] = "#" }
  when "R" then length.times { map[{row:, col: col += 1}] = "#" }
  when "U" then length.times { map[{row: row -= 1, col:}] = "#" }
  when "D" then length.times { map[{row: row += 1, col:}] = "#" }
  end
  max_row = [row, max_row].max
  max_col = [col, max_col].max
  min_row = [row, min_row].min
  min_col = [col, min_col].min
end

def flood_fill(map, row, col)
  queue = []
  queue << {row:, col:}
  seen = Set.new

  while queue.any?
    row, col = queue.pop.values_at(:row, :col)
    map[{row:, col:}] = "#"
    seen << {row:, col:}

    (-1..1).each do |dr|
      (-1..1).each do |dc|
        if map[{row: row + dr, col: col + dc}].nil? && !seen.include?({row: row + dr, col: col + dc})
          queue << {row: row + dr, col: col + dc}
        end
      end
    end
  end
end

flood_fill(map, 1, 1)

# (min_row..max_row).each do |row|
#   (min_col..max_col).each do |col|
#     print map[{row:, col:}] || "."
#   end
#   puts
# end
p map.size
