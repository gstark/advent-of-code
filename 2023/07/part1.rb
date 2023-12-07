# Could inline this into the one place it is used, but this keeps it more readable. ;)
def rank_hand(hand)
  sorted = hand.tally.values.sort
  case
  when sorted.last == 5         then 7 # five of kind
  when sorted.last == 4         then 6 # four of kind
  when sorted == [2,3]          then 5 # full house
  when sorted.last == 3         then 4 # three of kind
  when sorted.last(2) == [2, 2] then 3 # two pair
  when sorted.last == 2         then 2 # one pair
  else                               1 # high card
  end
end

p STDIN.readlines
  .map(&:split)
  .to_h { |cards, bid| [cards.chars.map { |card| "0123456789TJQKA".index(card) }, bid.to_i] }
  .map { |hand, bid| [rank_hand(hand), hand, bid] }
  .sort_by { |rank, hand, bid| [rank, hand] }
  .map.with_index { |(rank, hand, bid), index| bid * (index + 1) }
  .sum