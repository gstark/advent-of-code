instructions = STDIN.readlines(chomp: true)

memory = {}
bitmask = nil

instructions.each do |instruction|
  case
  when instruction.include?("mask")
    bitmask = instruction.match(/mask = (.*)/)[1].chars.map.with_index { |char, index| [char, index] }.reject { |char, index| char == "0" }
  else
    _, address, value = *instruction.match(/mem\[(\d*)\] = (\d*)/).to_a.map(&:to_i)

    address = address.to_s(2).rjust(36, "0")

    bitmask.each { |bit, offset| address[offset] = bit }

    count_x = address.count("X")

    bitmasks = (2 ** count_x).times.map do |n|
      string = n.to_s(2).rjust(count_x, "0").chars
      post_address = address.chars.map { |char, index| [char == "X" ? string.shift : char, index] }
      memory[post_address] = value
    end
  end
end

p memory.values.sum
