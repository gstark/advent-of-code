SEATS = STDIN.readlines(chomp: true).map(&:chars)

AROUND = [
  # Above
  [-1, -1],
  [-1, 0],
  [-1, 1],

  # On Same Row
  [0, -1],
  [0, +1],

  # Below
  [1, -1],
  [1, 0],
  [1, 1],
]

def print_generation(seats)
  puts "\e[H\e[2J"
  puts seats.map { |row| row.join }.join("\n")
  puts
end

def count_around_occupied(seats, row_number, column_number)
  AROUND.sum { |delta_row, delta_column|
    (1..).each { |distance|
      row = row_number + delta_row * distance
      col = column_number + delta_column * distance
      break 0 unless row.between?(0, seats.length - 1) && col.between?(0, seats[0].length - 1)
      break 0 if seats[row][col] == "L"
      break 1 if seats[row][col] == "#"
    }
  }
end

def generation(seats)
  seats.map.with_index { |row, row_number|
    row.map.with_index { |column, column_number|
      count = "L" == column || "#" == column ? count_around_occupied(seats, row_number, column_number) : 0
      case
      when column == "L" && count == 0 then "#"
      when column == "#" && count >= 5 then "L"
      else column
      end
    }
  }
end

previous_generation = SEATS
while true
  seats = generation(previous_generation)
  break if seats == previous_generation
  previous_generation = seats
end

p seats.sum { |row| row.count("#") }
