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
  puts seats.map { |row| row.join }.join("\n")
  puts
end

def count_around_occupied(seats, row_number, column_number)
  AROUND.count { |delta_row, delta_column| (row_number + delta_row).between?(0, seats.length - 1) && (column_number + delta_column).between?(0, seats[0].length - 1) && seats[row_number + delta_row][column_number + delta_column] == "#" }
end

def generation(seats)
  seats.map.with_index { |row, row_number|
    row.map.with_index { |column, column_number|
      count = count_around_occupied(seats, row_number, column_number)
      case
      when column == "L" && count == 0 then "#"
      when column == "#" && count >= 4 then "L"
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
print_generation(seats)

p seats.sum { |row| row.count("#") }
