inputs = ARGF.readline.chomp.chars

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

board = [
  "-------".chars
]

move_count = 0
rock_count = 0
piece_x = 2
piece_y = board.index { |line| !line.empty? } + 4
piece = ALL_PIECES[rock_count % ALL_PIECES.size]

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

cache = {}

loop do
  case inputs[move_count % inputs.size]
  when "<" then piece_x -= 1 unless overlap?(board, piece_x - 1, piece_y, piece)
  when ">" then piece_x += 1 unless overlap?(board, piece_x + 1, piece_y, piece)
  end

  if overlap?(board, piece_x, piece_y - 1, piece)
    board = render(board, piece_x, piece_y, piece)

    if cache[{piece: piece, top: board.last(4), input_index: move_count % inputs.size}]
      p rock_count
      p cache[{piece: piece, top: board.last(4), input_index: move_count % inputs.size}]
      print_board(board)
      break
    end

    cache[{piece: piece, top: board.last(4), input_index: move_count % inputs.size}] = board.length

    rock_count += 1

    piece = ALL_PIECES[rock_count % ALL_PIECES.size]

    piece_x = 2
    piece_y = board.rindex { |line| !line.empty? } + 4 + piece.max_by { |coord| coord[:y] }[:y]

    if rock_count == 2022
      # print_board(board)
      # p board.length - 1
      p cache
      break
    end
  else
    piece_y -= 1
  end

  move_count += 1
end
