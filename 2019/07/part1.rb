opcodes = ARGF.read.split(",").map(&:to_i)

# opcodes = [3, 15, 3, 16, 1002, 16, 10, 16, 1, 16, 15, 15, 4, 15, 99, 0, 0]

# Given opcodes, an instruction pointer, and an access mode
# return a valid value.
#
# If the mode is 0, we take the value at the instruction pointer
# as a relative value.
#
# If the mode is 1, we take the value as-is.
def value(opcodes, ip, mode)
  value = opcodes[ip]

  case mode
  when 0
    opcodes[value]
  when 1
    value
  else
    raise "WAT"
  end
end

def execute(opcodes, input)
  ip = 0
  loop do
    parameter_mode_3, parameter_mode_2, parameter_mode_1, op_high, op_low = opcodes[ip].to_s.rjust(5, "0").chars.map(&:to_i)

    code = op_high * 10 + op_low

    case code
    when 1
      one = value(opcodes, ip += 1, parameter_mode_1)
      two = value(opcodes, ip += 1, parameter_mode_2)

      opcodes[opcodes[ip += 1]] = one + two

      # Move the instruction pointer to the next opcode
      ip += 1
    when 2
      one = value(opcodes, ip += 1, parameter_mode_1)
      two = value(opcodes, ip += 1, parameter_mode_2)

      opcodes[opcodes[ip += 1]] = one * two

      # Move the instruction pointer to the next opcode
      ip += 1
    when 3
      value = input.shift
      opcodes[opcodes[ip += 1]] = value

      # Move the instruction pointer to the next opcode
      ip += 1
    when 4
      return opcodes[opcodes[ip += 1]]

      # Move the instruction pointer to the next opcode
      ip += 1
    when 5
      one = value(opcodes, ip += 1, parameter_mode_1)
      two = value(opcodes, ip += 1, parameter_mode_2)

      # Set the instruction pointer to the next opcode
      # if the first value is zero, otherwise we jump
      # to where the second value is pointing
      ip = one.zero? ? ip + 1 : two
    when 6
      one = value(opcodes, ip += 1, parameter_mode_1)
      two = value(opcodes, ip += 1, parameter_mode_2)

      # Set the instruction pointer to the second value
      # if the first value is zero, otherwise we move
      # one opcode forward
      ip = one.zero? ? two : ip + 1
    when 7
      one = value(opcodes, ip += 1, parameter_mode_1)
      two = value(opcodes, ip += 1, parameter_mode_2)

      # if the first value is less than the second
      # value we store a 1, otherwise a 0. We store
      # the value where the next opcode indicates
      opcodes[opcodes[ip += 1]] = one < two ? 1 : 0

      # Move the instruction pointer to the next opcode
      ip += 1
    when 8
      one = value(opcodes, ip += 1, parameter_mode_1)
      two = value(opcodes, ip += 1, parameter_mode_2)

      # if the first value is equal to the second
      # value we store a 1, otherwise a 0. We store
      # the value where the next opcode indicates
      opcodes[opcodes[ip += 1]] = one == two ? 1 : 0

      # Move the instruction pointer to the next opcode
      ip += 1
    when 99
      raise "EXIT"
    else
      raise "ERROR"
    end
  end
  raise "ERROR 2"
end

combos = [4, 3, 2, 1, 0].permutation(5).to_a

max = combos.map do |a, b, c, d, e|
  output = execute(opcodes.dup, [a, 0])
  output = execute(opcodes.dup, [b, output])
  output = execute(opcodes.dup, [c, output])
  output = execute(opcodes.dup, [d, output])

  execute(opcodes.dup, [e, output])
end.max
p max
