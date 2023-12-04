p STDIN
    .readlines(chomp: true)
    .map { |line| line.scan(/Card (.*): (.*)/).flatten }
    .map { |card, numbers| [card.to_i, numbers.split("|").map { |sequence| sequence.split.map(&:to_i) }]}
    .map { |card, (winning, have)| winning & have }
    .select { |matches| matches.length > 0 }
    .sum { |matches| 2 ** (matches.length - 1) }
