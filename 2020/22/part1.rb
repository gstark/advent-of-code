INPUT = STDIN.readlines(chomp: true)

player1, player2 = INPUT.select { |line| line =~ /^\d*$/ }.slice_before { |b| b.empty? }.map(&:to_a).map { |line| line.reject(&:empty?).map(&:to_i) }

def play_game(player1, player2)
  until player1.size == 0 || player2.size == 0
    card1 = player1.shift
    card2 = player2.shift

    if card1 > card2
      player1 << card1
      player1 << card2
    else
      player2 << card2
      player2 << card1
    end
  end

  return { player1: player1, player2: player2 }
end

p play_game(player1, player2).values.reduce(:+).reverse.map.with_index { |element, index| element * (index + 1) }.sum
