lines = $stdin.each_line(chomp: true)

answer = lines.sum do |line|
  line_chars = line.chars

  first = line_chars[...-1].max
  first_index = line_chars.index(first)

  last = line_chars[first_index + 1..].max

  "#{first}#{last}".to_i
end

p answer
