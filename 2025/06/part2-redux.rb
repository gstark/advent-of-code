answer = $stdin
  # Read the lines but exclude newlines
  #
  # ["123 328  51 64  ", " 45 64  387 23  ", "  6 98  215 314 ", "*   +   *   +   "]
  .readlines(chomp: true)
  # Turn this into a stream of characters
  #
  # [
  #   ["1", "2", "3", " ", "3", "2", "8", " ", " ", "5", "1", " ", "6", "4", " ", " "], [" ", "4", "5", " ", "6", "4", " ", " ", "3", "8", "7", " ", "2", "3", " ", " "], [" ", " ", "6", " ", "9", "8", " ", " ", "2", "1", "5", " ", "3", "1", "4", " "], ["*", " ", " ", " ", "+", " ", " ", " ", "*", " ", " ", " ", "+", " ", " ", " "]
  # ]
  .map(&:chars)
  # Transpose this so rows become columns and columns become rows
  #
  # [
  #   ["1", " ", " ", "*"],
  #   ["2", "4", " ", " "],
  #   ["3", "5", "6", " "],
  #   [" ", " ", " ", " "],
  #   ["3", "6", "9", "+"],
  #   ["2", "4", "8", " "],
  #   ["8", " ", " ", " "],
  #   [" ", " ", " ", " "],
  #   [" ", "3", "2", "*"],
  #   ["5", "8", "1", " "],
  #   ["1", "7", "5", " "],
  #   [" ", " ", " ", " "],
  #   ["6", "2", "3", "+"],
  #   ["4", "3", "1", " "],
  #   [" ", " ", "4", " "],
  #   [" ", " ", " ", " "]
  # ]
  .transpose
  # Chunk rows, using :_separator to drop empty rows and split groups
  #
  # [
  #   [
  #     true,
  #     [
  #       ["1", " ", " ", "*"],
  #       ["2", "4", " ", " "],
  #       ["3", "5", "6", " "]
  #     ]
  #   ],
  #   [
  #     true,
  #     [
  #       ["3", "6", "9", "+"],
  #       ["2", "4", "8", " "],
  #       ["8", " ", " ", " "]
  #     ]
  #   ],
  #   [
  #     true,
  #     [
  #       [" ", "3", "2", "*"],
  #       ["5", "8", "1", " "],
  #       ["1", "7", "5", " "]
  #     ]
  #   ],
  #   [
  #     true,
  #     [
  #       ["6", "2", "3", "+"],
  #       ["4", "3", "1", " "],
  #       [" ", " ", "4", " "]
  #     ]
  #   ]
  # ]
  .chunk { |chars| (chars.uniq == [" "]) ? :_separator : true }
  # Take the last character of the first row as the operator
  # and then turn each row of digits into a number (ignoring the chunk key)
  #
  # [
  #   [
  #     "*",
  #     [1, 24, 356]
  #   ],
  #   [
  #     "+",
  #     [369, 248, 8]
  #   ],
  #   [
  #     "*",
  #     [32, 581, 175]
  #   ],
  #   [
  #     "+",
  #     [623, 431, 4]
  #   ]
  # ]
  .map { |_chunk_key, rows| [rows.first.last, rows.map(&:join).map(&:to_i)] }
  # add or multiple the numbers together and sum the total
  .sum { |operator, numbers| numbers.inject(&operator.to_sym) }

p answer
