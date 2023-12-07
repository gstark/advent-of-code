def replace_one_joker(array_of_hands)
  # Turn the array of cards into a new array of cards
  # by removing a single joker and creating new hands
  # with all the possible combination
  array_of_hands.flat_map do |cards|
    cards.delete_at(cards.index(2))
    (0..14).reject { |card| card == 2 }.map { |new_card| cards + [new_card] }
  end
end

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

def rank(hand)
  all_hands = [hand.dup]
  while all_hands.any? { |hand| hand.include?(2) }  do
    all_hands = replace_one_joker(all_hands)
  end

  all_hands.map { |hand| rank_hand(hand) }.max
end

p STDIN.readlines
  .map(&:split)
  .to_h { |cards, bid| [cards.chars.map { |card| "01J23456789TQKA".index(card) }, bid.to_i] }
  .map { |cards, bid| [rank(cards), cards, bid] }
  .sort_by { |rank, cards, bid| [rank, cards] }
  .map.with_index { |(rank, cards, bid), index| bid * (index + 1) }
  .sum