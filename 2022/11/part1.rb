instructions = ARGF.readlines(chomp: true)

monkeys = instructions.each_slice(7).map.with_index do |instructions, index|
  {
    number: index,
    items: instructions[1].scan(/\d+/).map(&:to_i),
    operation: instructions[2].scan(/new = (.*) ([+*]) (.*)/).first,
    divisible: instructions[3].scan(/\d+/).first.to_i,
    monkey_true: instructions[4].scan(/\d+/).first.to_i,
    monkey_false: instructions[5].scan(/\d+/).first.to_i,
    inspected: 0
  }
end

20.times do
  monkeys.each do |monkey|
    while (item = monkey[:items].shift)
      monkey[:inspected] += 1

      new_item_level = case monkey[:operation]
      in ["old", "*", "old"] then item * item
      in ["old", "+", "old"] then item + item
      in ["old", "*", operand] then item * operand.to_i
      in ["old", "+", operand] then item + operand.to_i
      end
      new_item_level /= 3

      if new_item_level % monkey[:divisible] == 0
        monkeys[monkey[:monkey_true]][:items] << new_item_level
      else
        monkeys[monkey[:monkey_false]][:items] << new_item_level
      end
    end
  end
end

p monkeys.map { |monkey| monkey[:inspected] }.sort.last(2).reduce(:*)
