p STDIN
    .readlines(chomp: true)
    .map { |line| line.scan(/Card (.*): (.*)/).flatten }
    .map { |card, numbers| [card.to_i, numbers.split("|").map { |sequence| sequence.split.map(&:to_i) }] }
    .to_h { |card, (winning, have)| [card, {matches: (winning & have).length, copies: 1}] }
    .yield_self { |cards| cards.each { |card, details| (card+1...card+details[:matches]+1).each { |card2| cards[card2][:copies] += details[:copies] } } }
    .sum { |card, details| details[:copies] }
