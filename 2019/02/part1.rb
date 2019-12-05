# Read the opcodes
opcodes = ARGF.read.split(",").map(&:to_i)

# Set the codes we need
opcodes[1] = 12
opcodes[2] = 2

# Start the instruction pointer at 0
ip = 0

loop do
  # Split the next four opcodes
  opcode, op1, op2, target = opcodes[ip..ip + 4]

  case opcode
  when 1
    # If the opcode is SUM, add the two values together
    # and store them at the target location
    opcodes[target] = opcodes[op1] + opcodes[op2]
  when 2
    # If the opcode is MULTIPLY, multiply the two values together
    # and store them at the target location
    opcodes[target] = opcodes[op1] * opcodes[op2]
  when 99
    break
  end

  # Move the instruction pointer ahead
  ip += 4
end

p opcodes
