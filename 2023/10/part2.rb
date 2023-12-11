require "debug"
require "set"

MOVES = {
  "L" => [[-1, +0], [+0, +1]],
  "J" => [[+0, -1], [-1, +0]],
  "|" => [[-1, +0], [+1, +0]],
  "-" => [[+0, -1], [+0, +1]],
  "7" => [[+0, -1], [+1, +0]],
  "F" => [[+0, +1], [+1, +0]]
}

file = $stdin # File.open("input.txt")
original_start = file.readline(chomp: true)

board = file
  .readlines(chomp: true)
  .slice(..-2)
  .each.with_index.with_object({}) { |(line, row), board| line.chars.each.with_index { |char, col| board[[row, col]] = char } }

$height = board.keys.map(&:first).max + 1
$width = board.keys.map(&:last).max + 1

start = board.rassoc("S").first
board[start] = original_start

def find_loop(start, board)
  path = Set.new

  current = start
  (0..).each do |index|
    move = MOVES.fetch(board[current]).find { |move| !path.include?([current[0] + move[0], current[1] + move[1]]) }

    break (path << current) if move.nil?
    path << current
    current = [current[0] + move[0], current[1] + move[1]]
  end
end

def print_board(board, star_pos = nil)
  (0..$height).each do |row|
    puts (0..$width).map { |col| (star_pos == [row, col]) ? "*" : board[[row, col]] }.join
  end

  5.times { puts }
end

# For all solutions we set
# anything that isn't part
# of the loop to '.' since
# it really doesn't matter
found_loop = find_loop(start, board)
$height.times.each do |row|
  $width.times.each do |col|
    board[[row, col]] = "." unless found_loop.include?([row, col])
  end
end

def hyper_neutrino(found_loop, board)
  # github: hyper-neutrino
  $height.times.each do |row|
    outside = true

    # Assume vertically DOWN
    up = false
    down = true
    $width.times.each do |col|
      ch = board[[row, col]]
      case ch
      # If we experience a | we know we are
      # moving from inside to outside
      when "|"
        outside = !outside
      # If we experience an L we are now
      # moving upward
      when "L"
        up = true
        down = false
      # If we experience an F we are now
      # moving downward
      when "F"
        up = false
        down = true
      # If we hit a 7 it must be from an F---
      # sequence and thus if we we moving up
      # then we toggle if we are outside
      when "7"
        if up
          outside = !outside
        end
      # If we hit a J it must be from an L---
      # sequence and thus if we we moving down
      # then we toggle if we are outside
      when "J"
        if down
          outside = !outside
        end
      end

      #
      # We could invert the up/down
      # logic from the L/F by also
      # inverting the J/7 logic
      #

      # when "L"
      #   up = false
      # when "F"
      #   up = true
      # when "7"
      #   if down
      #     outside = !outside
      #   end
      # when "J"
      #   if up
      #     outside = !outside
      #   end
      # end

      if outside
        board[[row, col]] = "O"
      end
    end
  end

  found_loop.each do |row, col|
    board[[row, col]] = "O"
  end
  # print_board(board)

  board.flatten.count(".")
end
p hyper_neutrino(found_loop, board.dup)

# https://en.wikipedia.org/wiki/Even%E2%80%93odd_rule
def even_odd_rule(found_loop, board)
  # for every row we will sum ...
  $height.times.sum do |row|
    # ... the number of columns for which the following is true ...
    $width.times.count do |col|
      # ... we are not on the loop itself
      !found_loop.include?([row, col]) &&
        # ... and we cross VERTICAL pipes an odd number of times
        # ... getting to the edge of the map
        (0..col).count { |col2| "L|J".include?(board[[row, col2]]) }.odd?
    end
  end
end
p even_odd_rule(found_loop, board.dup)
