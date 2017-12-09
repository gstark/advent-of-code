def group_score(base_score, sequence, scores)
  score = 1
  sub_sequence = sequence[1..-2]

  chars = sub_sequence.chars
  index = 0
  loop do
    if index >= sub_sequence.length
      scores << base_score + score
      return scores
    end

    if chars[index] == "{"
      sub_group = "{"
      open_bracket_count = 1
      loop do
        index += 1
        sub_group << chars[index]
        open_bracket_count += 1 if chars[index] == "{"
        open_bracket_count -= 1 if chars[index] == "}"

        break if open_bracket_count == 0
      end
      group_score(base_score + score, sub_group, scores)
    end
    index += 1
  end
end

p File.readlines("09-input.txt").map { |line| group_score(0, line.gsub(/!./, "").gsub(/<.*?>/, ""), []).sum }.sum
