
die = Enumerator.new do |yielder|
  (1..100).cycle.each do |die|
    yielder << die
  end
end

players = [nil, 6, 10]
scores = [nil, 0, 0]

rolls = 0
winner = [1,2].cycle do |player|
  3.times do
    score = die.next
    rolls += 1
    score.times do
      players[player] += 1
      players[player] = 1 if players[player] > 10
    end
  end
  scores[player] += players[player]

  break player if scores[player] >= 1000
end

p scores.compact.min * rolls