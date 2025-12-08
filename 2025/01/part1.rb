position = 50

p $stdin
  .readlines(chomp: true)
  .map { |line| [(line[0] == "L") ? -1 : 1, line[1..].to_i] }
  .map { |dir, dist| position = (position + (dir * dist)) % 100 }
  .count(0)
