CARDS = "01J23456789TQKA"
JOKER_INDEX = CARDS.index("J")

FIVE_KIND = 7
FOUR_KIND = 6
FULL_HOUSE = 5
THREE_KIND = 4
TWO_PAIR = 3
ONE_PAIR = 2
HIGH_CARD = 1

RANKS = {
  [5] => FIVE_KIND,
  [1, 4] => FOUR_KIND,
  [2, 3] => FULL_HOUSE,
  [1, 1, 3] => THREE_KIND,
  [1, 2, 2] => TWO_PAIR,
  [1, 1, 1, 2] => ONE_PAIR,
  [1, 1, 1, 1, 1] => HIGH_CARD
}

p $stdin.readlines
  .map(&:split)
  # Turn the cards into their respective value based on their index in the CARDS string
  # this will give them the correct sorting index. Since we don't care about the actual
  # representation we can deal with the cards as their value.
  .map { |cards, bid| [cards.chars.map { |card| CARDS.index(card) }, bid.to_i] }
  # turn this into an array of the rank of the cards themselves, the cards and the bid
  # We replace the joker with the most common card before we process the rank
  .map { |cards, bid| [RANKS.fetch(cards.map { |card| card == JOKER_INDEX ? (cards - [JOKER_INDEX]).tally.max_by { |card, count| count }&.first : card }.tally.values.sort), cards, bid] }
  # sort them, this sorts by rank first, then by the cards and finally by the bid
  .sort
  # now generate their scaled value
  .each.with_index.sum { |(rank, cards, bid), index| bid * (index + 1) }
