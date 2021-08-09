input = STDIN.read
  numbers = input.split("\n").map(&:to_i)
  numbers.find { |number| numbers.find { |number2| number + number2 == 2020 } }