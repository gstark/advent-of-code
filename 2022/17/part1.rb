inputs = ARGF.readline.chomp.chars.cycle

BLANK_LINE = [nil, nil, nil, nil, nil, nil, nil]

ALL_PIECES = [
  #   ####
  [
    {x: 0, y: 0},{x: 1, y: 0},{x: 2, y: 0},{x: 3, y: 0}
  ],
  #   .#.
  #   ###
  #   .#.
  [              {x: 1, y: 0},
    {x: 0, y: 1},{x: 1, y: 1},{x: 2, y: 1},
                 {x: 1, y: 2}
  ],
  #   ..#
  #   ..#
  #   ###
  [
                              {x: 2, y: 0},
                              {x: 2, y: 1},
    {x: 0, y: 2},{x: 1, y: 2},{x: 2, y: 2},
  ],
  #  #
  #  #
  #  #
  #  #
  [
    {x: 0, y: 0},
    {x: 0, y: 1},
    {x: 0, y: 2},
    {x: 0, y: 3},
  ],
  #  ##
  #  ##
  [
    {x: 0, y: 0}, {x: 1, y: 0},
    {x: 0, y: 1}, {x: 1, y: 1}
  ]
]

pieces = ALL_PIECES.cycle

board = [
  "-------".chars
]

rock_count = 0
piece_x = 2
piece_y = board.index { |line| !line.empty? } + 4
piece = pieces.next

def overlap?(board, x, y, piece)
  return true if x - piece.min_by { |coord| coord[:x] }[:x] < 0
  return true if x + piece.max_by { |coord| coord[:x] }[:x] > 6

  piece.any? { |coord| board[y - coord[:y]] && board[y - coord[:y]][x + coord[:x]] }
end

def render(board, x, y, piece, char = "#")
  new_board = board.map { |line| line.dup }

  piece.each do |coord|
    new_board[y - coord[:y]] ||= BLANK_LINE.dup
    new_board[y - coord[:y]][x + coord[:x]] = char
  end

  new_board
end

def print_board(board)
  board.reverse_each do |line|
    (line || BLANK_LINE).each { |char| print char || "." }
    puts
  end
  puts
end

loop do
  case inputs.next
  when "<" then piece_x -= 1 unless overlap?(board, piece_x - 1, piece_y, piece)
  when ">" then piece_x += 1 unless overlap?(board, piece_x + 1, piece_y, piece)
  end

  if overlap?(board, piece_x, piece_y - 1, piece)
    board = render(board, piece_x, piece_y, piece)

    rock_count += 1

    p [board.length - 1, ALL_PIECES.index(piece)]

    piece = pieces.next

    piece_x = 2
    piece_y = board.rindex { |line| !line.empty? } + 4 + piece.max_by { |coord| coord[:y] }[:y]

    if rock_count == 2022
      p board.length - 1
      break
    end
  else
    piece_y -= 1
  end
end
