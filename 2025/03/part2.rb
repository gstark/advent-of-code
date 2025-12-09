lines = $stdin.readlines(chomp: true)

def largest(memory, source, remaining)
  answers = source.chars.each.with_index.map do |digit, right_index|
    new_source = source[right_index + 1..]
    new_remaining = remaining - 1

    memory[[digit, new_source, new_remaining]] ||= digit + largest(memory, new_source, new_remaining)
  end

  answers.select { |answer| answer.to_s.length == remaining }.max || ""
end

answer = lines.sum do |line|
  line_answer = largest({}, line, 12).to_i
  p [line, line_answer]
  line_answer
end

puts
p answer
# 171741365473332

# # Answer from reading other solutions
# lines = $stdin.readlines(chomp: true).map { |line| line.chars.map(&:to_i) }
# answer = lines.sum do |line|
#   12.downto(1).reduce(0) do |line_total, size|
#     all_but_last_size_digits = line[0..-size]
#     max = all_but_last_size_digits.max
#     index_of_max = line.index(max)

#     line = line[index_of_max + 1..]

#     line_total * 10 + max
#   end
# end
