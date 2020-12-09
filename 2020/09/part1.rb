NUMBERS = STDIN.read.split("\n").map(&:to_i)

(26..NUMBERS.length).each do |index|
  possibilities = NUMBERS[index - 25...index]
  if !possibilities.combination(2).map(&:sum).include?(NUMBERS[index])
    p NUMBERS[index]
    break
  end
end
