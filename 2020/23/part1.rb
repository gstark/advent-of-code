cups = 389125467.digits.reverse
count = 100

cups = 712643589.digits.reverse
count = 100

count.times do |turn|
  current_cup = cups[turn % 9]

  moving_cups = cups.slice!((turn + 1) % 9, 3)
  moving_cups.concat(cups.slice!(0, 3 - moving_cups.size))

  destination = current_cup == 1 ? 9 : current_cup - 1
  destination = (destination == 1 ? 9 : destination - 1) while moving_cups.include?(destination)

  cups.insert(cups.index(destination) + 1, *moving_cups)

  rotate = cups.index(current_cup) - turn % 9
  cups.rotate!(rotate) if (rotate > 0)

  p cups
end

puts (cups[cups.index(1) + 1..] + cups[0..cups.index(1)]).cycle.take(8).join
