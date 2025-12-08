input = $stdin
  .read
  .scan(/(\d+)-(\d+)/)
  .map { |a, b| [a.to_i, b.to_i] }

answer = input.flat_map do |first, last|
  (first..last).select do |candidate|
    digits = candidate.to_s

    (0...digits.length / 2).any? { |span| digits == digits[0..span] * (digits.length / (span + 1)) }
  end
end

p answer.sum
