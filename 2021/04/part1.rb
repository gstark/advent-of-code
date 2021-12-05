require 'awesome_print'


# P E D A

# Problem
#
# We want to find the first bingo card out of the set of bingo cards we are given that has
# either a vertical or horizontal winning state. A winning state is all of the numbers in
# that row or column having been called so far.
#
#
# EXAMPLE (from our problem statement)
#
# Data Structure
#
# The called numbers: array of numbers. (input is a string so likely need to split and convert)
#
# The boards will be represented by a THREE dimensional array
# - first dimension is the board number
# - second dimension will be the row
# - third dimesnion will be the column
#
# boards[0]
#
# 37 72 60 35 89    <=== boards[0][0]        boards[0][0][0] = 37, boards[0][0][1] = 72
# 32 49  4 77 82    <=== boards[0][1]
# 30 26 27 63 88    <=== boards[0][2]
# 29 43 16 34 58    <=== boards[0][3]
# 48 33 96 79 94    <=== boards[0][4]
# 
# 41 94 77 43 87
#  2 17 82 96 25
# 95 49 32 12  9
# 59 33 67 71 64
# 88 54 93 85 30
# 
# 78 84 73 64 81
#  6 66 54 21 15
# 72 88 69  5 93
# 11 96 38 95 44
# 13 41 94 55 48
#
#
# Algorithm
#
# Read the first line of input and store the numbers called
#
# Read through the rest of the file generating our boards datastructure
#
# Loop through the numbers called and for each number:
# - Loop through each board, marking any instance of that number as "seen" (by replacing it with a 0)
# - Check if that yields a winning state. If so, do "the calculation" (come back to this)
# - Otherwise, keep moving through the other boards
#
# - Calculation is the sum of all the non-nil elements multiplied by the current called number

lines = STDIN.read.split("\n")

numbers = lines[0].split(",").map(&:to_i)

boards = lines[1..].each_slice(6).map { |board_lines| board_lines[1..].map { |board_line| board_line.split.map(&:to_i) } }.to_a

# Loop through the numbers called and for each number:
winning_number = numbers.find do |number|
  # - Loop through each board, marking any instance of that number as "seen" (by replacing it with a 0)
  boards.find do |board|
    board.each do |row|
      # Go through the column and change any instances of `number` to nil
      row.map! { |column| column == number ? nil : column}
    end

    # Check if there is a winning state
    # - Check if any row is all nil
    # - Check if any column is all nil
    board.any? { |row| row.all? { |column| column.nil? }} ||
    board.transpose.any? { |row| row.all? { |column| column.nil? }}
  end
end

# - Calculation is the sum of all the elements multiplied by the current called number
winning_board = boards.find { |board| 
  board.any? { |row| row.all? { |column| column.nil? }} ||
  board.transpose.any? { |row| row.all? { |column| column.nil? }}
}

ap winning_number * winning_board.flatten.compact.sum