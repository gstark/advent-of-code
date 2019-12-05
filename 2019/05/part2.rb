# This is basically the same as `part1` with support for
# a few new opcodes. We also don't _assume_ we can move
# the instruction pointer after each evaluation. Instead
# we move the instruction pointer as needed for each opcode
opcodes = ARGF.read.split(",").map(&:to_i)

ip = 0

def value(opcodes, ip, mode)
  value = opcodes[ip]

  case mode
  when 0 then opcodes[value]
  when 1 then value
  else raise "WAT"
  end
end

loop do
  parameter_mode_3, parameter_mode_2, parameter_mode_1, op_high, op_low = opcodes[ip].to_s.rjust(5, "0").chars.map(&:to_i)

  case op_high * 10 + op_low
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
    opcodes[opcodes[ip += 1]] = 5

    # Move the instruction pointer to the next opcode
    ip += 1
  when 4
    p opcodes[opcodes[ip += 1]]

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
    break
  else
    raise "WAT"
  end
end
