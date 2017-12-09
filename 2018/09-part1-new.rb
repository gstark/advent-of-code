def group_score(sequence)
  0.tap do |score|
    current_score = 0
    sequence.chars.each do |char|
      score += (current_score += 1) if char == "{"
      current_score -= 1 if char == "}"
    end
  end
end

input = File.read("09-input.txt")
p group_score(input.gsub(/!./, "").gsub(/<.*?>/, ""))
