def light_gray(text)
  "\e[37m#{text}\e[0m"
end

def bright_white(text)
  "\e[31m#{text}\e[0m"
end

def score_path(path, print: false)
  if print
    new_grid = GRID.map(&:dup)

    path.each { |details|
      row, col, direction = details.values_at(:row, :col, :incoming_direction)

      new_grid[row][col] = case direction
      when "left" then "<"
      when "right" then ">"
      when "down" then "v"
      when "up" then "^"
      else GRID[row][col]
      end
    }

    (0...GRID.length).each do |row|
      (0...GRID[0].length).each do |col|
        value = new_grid[row][col]
        print((0..9).cover?(value) ? light_gray(value) : bright_white(value))
      end
      puts
    end
  end
end