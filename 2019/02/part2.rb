source = ARGF.read.split(",").map(&:to_i)

# Loop through all values of the first noun and the first verb
(0..99).each do |first_noun|
  (0..99).each do |first_verb|
    # Copy the source opcodes to the opcodes variable. This is
    # so we can modify opcodes without modifying the `source`
    opcodes = source.dup

    # Put these two values in place
    opcodes[1] = first_noun
    opcodes[2] = first_verb

    instruction_pointer = 0

    loop do
      # Split the opcodes
      opcode, noun, verb, target = opcodes[instruction_pointer..instruction_pointer + 4]

      case opcode
      when 1
        # Add opcode
        opcodes[target] = opcodes[noun] + opcodes[verb]
      when 2
        # Multiply opcode
        opcodes[target] = opcodes[noun] * opcodes[verb]
      when 99
        # Program end. Check for the magic value
        if opcodes[0] == 19690720
          # If this is a valid magic value, print the answer and stop
          p first_noun * 100 + first_verb
          exit
        end

        # Otherwise break out of the `loop do`
        break
      end
      instruction_pointer += 4
    end
  end
end
