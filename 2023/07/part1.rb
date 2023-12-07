# Could inline this into the one place it is used, but this keeps it more readable. ;)
def rank(cards)
  sorted = cards.tally.values.sort
  return 7 if sorted.last == 5         # five of kind
  return 6 if sorted.last == 4         # four of kind
  return 5 if sorted == [2,3]          # full house
  return 4 if sorted.last == 3         # three of kind
  return 3 if sorted.last(2) == [2, 2] # two pair
  return 2 if sorted.last == 2         # one pair
  return 1
end

p STDIN.readlines
  .map(&:split)
  .to_h { |cards, bid| [cards.chars.map { |card| "0123456789TJQKA".index(card) }, bid.to_i] }
  .map { |cards, bid| [rank(cards), cards, bid] }
  .sort_by { |rank, cards, bid| [rank, cards] }
  .map.with_index { |(rank, cards, bid), index| bid * (index + 1) }
  .sum