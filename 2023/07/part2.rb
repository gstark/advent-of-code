CARDS = "01J23456789TQKA"
JOKER_INDEX = CARDS.index("J")

FIVE_KIND = 7
FOUR_KIND = 6
FULL_HOUSE = 5
THREE_KIND = 4
TWO_PAIR = 3
ONE_PAIR = 2
HIGH_CARD = 1

# Could inline this, but this keeps it more readable. ;)
def rank(hand)
  # Split the cards into jokers and non jokers
  jokers, non_jokers = hand.partition { |card| card == JOKER_INDEX }

  if jokers.any?
    # If there are jokers, rank the non jokers and determine the best
    # possible hand based on that rank and the number of jokers
    if jokers.length == 1 && rank(non_jokers) == HIGH_CARD
      ONE_PAIR
    elsif jokers.length == 1 && rank(non_jokers) == ONE_PAIR
      THREE_KIND
    elsif jokers.length == 1 && rank(non_jokers) == TWO_PAIR
      FULL_HOUSE
    elsif jokers.length == 1 && rank(non_jokers) == THREE_KIND
      FOUR_KIND
    elsif jokers.length == 1 && rank(non_jokers) == FOUR_KIND
      FIVE_KIND
    elsif jokers.length == 2 && rank(non_jokers) == HIGH_CARD
      THREE_KIND
    elsif jokers.length == 2 && rank(non_jokers) == ONE_PAIR
      FOUR_KIND
    elsif jokers.length == 2 && rank(non_jokers) == THREE_KIND
      FIVE_KIND
    elsif jokers.length == 3 && rank(non_jokers) == HIGH_CARD
      FOUR_KIND
    elsif jokers.length == 3 && rank(non_jokers) == ONE_PAIR
      FIVE_KIND
    else
      FIVE_KIND
    end
  else
    # Standard ranking, but we may have fewer than five cards
    # and we won't have any jokers to contend with
    sorted = non_jokers.tally.values.sort

    if sorted.last == 5
      FIVE_KIND
    elsif sorted.last == 4
      FOUR_KIND
    elsif sorted == [2, 3]
      FULL_HOUSE
    elsif sorted.last == 3
      THREE_KIND
    elsif sorted.last(2) == [2, 2]
      TWO_PAIR
    elsif sorted.last == 2
      ONE_PAIR
    else
      HIGH_CARD
    end
  end
end

p $stdin.readlines
  .map(&:split)
  # Turn the cards into their respective value based on their index in the CARDS string
  # this will give them the correct sorting index. Since we don't care about the actual
  # representation we can deal with the cards as their value.
  .map { |cards, bid| [cards.chars.map { |card| CARDS.index(card) }, bid.to_i] }
  # turn this into an array of the rank of the cards themselves, the cards and the bid
  .map { |cards, bid| [rank(cards), cards, bid] }
  # sort them, this sorts by rank first, then by the cards and finally by the bid
  .sort
  # now generate their scaled value
  .each.with_index.sum { |(rank, cards, bid), index| bid * (index + 1) }
