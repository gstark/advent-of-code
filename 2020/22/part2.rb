require "amazing_print"
require "set"

INPUT = STDIN.readlines(chomp: true)

player1, player2 = INPUT.select { |line| line =~ /^\d*$/ }.slice_before { |b| b.empty? }.map(&:to_a).map { |line| line.reject(&:empty?).map(&:to_i) }

def play_game(player1, player2)
  seen_cards = Set.new

  until player1.size == 0 || player2.size == 0
    return { p1wins: 1 } if seen_cards.include?([player1.join("-"), player2.join("-")])

    seen_cards << [player1.join("-"), player2.join("-")]

    card1 = player1.shift
    card2 = player2.shift

    p1wins = if player1.size >= card1 && player2.size >= card2
        play_game(player1.take(card1), player2.take(card2))[:p1wins]
      else
        card1 > card2
      end

    if p1wins
      player1 << card1
      player1 << card2
    else
      player2 << card2
      player2 << card1
    end
  end

  return player2.size == 0 ? { winning_cards: player1, p1wins: true } : { winning_cards: player2, p1wins: false }
end

p play_game(player1, player2)[:winning_cards].reverse.map.with_index { |element, index| element * (index + 1) }.sum
