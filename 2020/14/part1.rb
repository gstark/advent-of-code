instructions = STDIN.readlines(chomp: true)

memory = {}
bitmask = nil

instructions.each do |instruction|
  case
  when instruction.include?("mask")
    bitmask = instruction.match(/mask = (.*)/)[1].chars.map.with_index { |char, index| [char, index] }.reject { |char, offset| char == "X" }
  else
    _, address, value = *instruction.match(/mem\[(\d*)\] = (\d*)/).to_a.map(&:to_i)

    value = value.to_s(2).rjust(36, "0")

    bitmask.each { |bit, offset| value[offset] = bit }

    memory[address] = value.to_i(2)
  end
end

p memory.values.sum
