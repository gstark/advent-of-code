DIGITS = %w[zero one two three four five six seven eight nine]

puts STDIN.readlines(chomp: true)
  .sum { |line|
          [
            line.sub(Regexp.new(DIGITS.join("|"))) { |match| DIGITS.index(match) }.scan(/\d/).first.to_i,
            line.reverse.sub(Regexp.new(DIGITS.map(&:reverse).join("|"))) { |match| DIGITS.index(match.reverse) }.reverse.scan(/\d/).last.to_i
          ].join.to_i
       } 