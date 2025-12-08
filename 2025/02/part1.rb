input = $stdin
  .read
  .scan(/(\d+)-(\d+)/)
  .map { |a, b| [a.to_i, b.to_i] }

answer = input.sum do |first, last|
  (first..last).sum do |candidate|
    digits = candidate.to_s

    next 0 if digits.length.odd?

    half_length = digits.length / 2
    left = digits[0...half_length]
    right = digits[half_length..]

    (left == right) ? candidate : 0
  end
end
p answer
