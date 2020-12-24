def print_hash(head, hash, join = " ")
  final_cups = [head]
  (hash.size - 1).times { final_cups << hash[final_cups.last] }
  final_cups.join(join)
end

cups = 712643589.digits.reverse
count = 10_000_000
size = 1_000_000

hash = Array.new(count + 1)
cups.each_cons(2) { |a, b| hash[a] = b }
(10..size).each_cons(2) { |a, b| hash[a] = b }
hash[cups.last] = 10
hash[size] = cups.first

head = cups.first

count.times do |turn|
  a, b, c = [hash[head], hash[hash[head]], hash[hash[hash[head]]]]

  after = head
  loop do
    after = (after == 1 ? size : after - 1)
    break unless after == a || after == b || after == c
  end

  hash[after], hash[c], hash[head] = [a, hash[after], hash[c]]

  head = hash[head]
end

p hash[1] * hash[hash[1]]
