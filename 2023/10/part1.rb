require 'set'

MOVES = {
  "L" => [[-1,+0], [+0,+1]],
  "J" => [[+0,-1], [-1,+0]],
  "|" => [[-1,+0], [+1,+0]],
  "-" => [[+0,-1], [+0,+1]],
  "7" => [[+0,-1], [+1,+0]],
  "F" => [[+0,+1], [+1,+0]] ,
}

board = $stdin
  .readlines(chomp: true)
  .each.with_index.with_object({}) { |(line, row), board| line.chars.each.with_index { |char, col| board[[row,col]] = char } }

start = board.rassoc("S").first

board[start] = "J" # HACK to set the initial position for the input puzzle. TODO: Make this dynamic
path = Set.new

current = start
answer = (0..).each do |index|
  move = MOVES.fetch(board[current]).find { |move| !path.include?([current[0] + move[0], current[1] + move[1]]) }

  break index if move.nil?
  path << current
  current = [current[0] + move[0], current[1] + move[1]]
end

p (answer + 1)/2