position = 50

count = 0
$stdin
  .readlines(chomp: true)
  .map { |line| [(line[0] == "L") ? -1 : 1, line[1..].to_i] }
  .each { |(dir, dist)| dist.times { position, count = [(position + dir) % 100, ((position + dir) % 100 == 0) ? count + 1 : count] } }

p count

# 6858
# 