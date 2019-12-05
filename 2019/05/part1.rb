opcodes = ARGF.read.split(",").map(&:to_i)

ip = 0

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

loop do
  # Take the current opcode, pad it with a 0 to make a 5 character string, then turn this back into integers
  parameter_mode_3, parameter_mode_2, parameter_mode_1, op_high, op_low = opcodes[ip].to_s.rjust(5, "0").chars.map(&:to_i)

  # The opcode is the two digits made up of op_high and op_low
  case op_high.to_i * 10 + op_low.to_i
  when 1
    # Get the absolute/relative value for the next two opcodes
    # based on the paramter modes
    one = value(opcodes, ip += 1, parameter_mode_1)
    two = value(opcodes, ip += 1, parameter_mode_2)

    # Store the result of adding
    opcodes[opcodes[ip += 1]] = one + two
  when 2
    # Get the absolute/relative value for the next two opcodes
    # based on the paramter modes
    one = value(opcodes, ip += 1, parameter_mode_1)
    two = value(opcodes, ip += 1, parameter_mode_2)

    # Store the result of multiplying
    opcodes[opcodes[ip += 1]] = one * two
  when 3
    # Store the "input"
    opcodes[opcodes[ip += 1]] = 1
  when 4
    # Print an output
    p opcodes[opcodes[ip += 1]]
  when 99
    # Terminate
    break
  else
    raise "WAT"
  end

  # Move the instruction pointer one further
  # since we need to be on the *next* opcode
  ip += 1
end
