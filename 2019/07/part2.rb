opcodes = ARGF.read.split(",").map(&:to_i)

opcodes = [3, 26, 1001, 26, -4, 26, 3, 27, 1002, 27, 2, 27, 1, 27, 26, 27, 4, 27, 1001, 28, -1, 28, 1005, 28, 6, 99, 0, 0, 5]

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

Terminate = Class.new(StandardError)

class Program
  def initialize(name, opcodes)
    @name = name
    @opcodes = opcodes.dup
    @ip = 0
  end

  def execute(input)
    opcodes = @opcodes.dup

    loop do
      parameter_mode_3, parameter_mode_2, parameter_mode_1, op_high, op_low = opcodes[@ip].to_s.rjust(5, "0").chars.map(&:to_i)

      code = op_high * 10 + op_low

      case code
      when 1
        one = value(opcodes, @ip += 1, parameter_mode_1)
        two = value(opcodes, @ip += 1, parameter_mode_2)

        puts "\n Adding #{one} and #{two} for #{one + two} and storing at #{opcodes[@ip + 1]}\n"
        opcodes[opcodes[@ip += 1]] = one + two

        # Move the instruction pointer to the next opcode
        @ip += 1
      when 2
        one = value(opcodes, @ip += 1, parameter_mode_1)
        two = value(opcodes, @ip += 1, parameter_mode_2)

        puts "\n Mult #{one} and #{two} for #{one * two} and storing at #{opcodes[@ip + 1]}\n"
        opcodes[opcodes[@ip += 1]] = one * two

        # Move the instruction pointer to the next opcode
        @ip += 1
      when 3
        value = input.shift
        puts "\n Storing #{value} at #{opcodes[@ip + 1]}\n"
        opcodes[opcodes[@ip += 1]] = value

        # Move the instruction pointer to the next opcode
        @ip += 1
      when 4
        result = opcodes[opcodes[@ip += 1]]

        # Move the instruction pointer to the next opcode
        @ip += 1

        p(return: true, name: @name, value: result, ip: @ip, code: opcodes[@ip])
        return [:return, result]
      when 5
        one = value(opcodes, @ip += 1, parameter_mode_1)
        two = value(opcodes, @ip += 1, parameter_mode_2)

        # Set the instruction pointer to the next opcode
        # if the first value is zero, otherwise we jump
        # to where the second value is pointing
        puts "\n If zero #{one} jump to #{@ip + 1} or #{two}\n"
        @ip = one.zero? ? @ip + 1 : two
      when 6
        one = value(opcodes, @ip += 1, parameter_mode_1)
        two = value(opcodes, @ip += 1, parameter_mode_2)

        # Set the instruction pointer to the second value
        # if the first value is zero, otherwise we move
        # one opcode forward
        puts "\n If zero #{one} jump to #{two} or #{@ip + 1}\n"
        @ip = one.zero? ? two : @ip + 1
      when 7
        one = value(opcodes, @ip += 1, parameter_mode_1)
        two = value(opcodes, @ip += 1, parameter_mode_2)

        # if the first value is less than the second
        # value we store a 1, otherwise a 0. We store
        # the value where the next opcode indicates
        puts "\n If #{one} < #{two} store 1 or 0 at #{opcodes[@ip + 1]}\n"
        opcodes[opcodes[@ip += 1]] = one < two ? 1 : 0

        # Move the instruction pointer to the next opcode
        @ip += 1
      when 8
        one = value(opcodes, @ip += 1, parameter_mode_1)
        two = value(opcodes, @ip += 1, parameter_mode_2)

        # if the first value is equal to the second
        # value we store a 1, otherwise a 0. We store
        # the value where the next opcode indicates
        puts "\n If #{one} = #{two} store 1 or 0 at #{opcodes[@ip + 1]}\n"
        opcodes[opcodes[@ip += 1]] = one == two ? 1 : 0

        # Move the instruction pointer to the next opcode
        @ip += 1
      when 99
        # @ip = 0
        p(end: true, name: @name, ip: @ip, code: opcodes[@ip])
        return [:terminate]
      else
        raise "ERROR opcode=#{code}"
      end
    end
    raise "ERROR 2"
  end

  def reset
    # @ip = 0
  end
end

combos = [5, 6, 7, 8, 9].permutation(5).to_a

a_program = Program.new("a", opcodes)
b_program = Program.new("b", opcodes)
c_program = Program.new("c", opcodes)
d_program = Program.new("d", opcodes)
e_program = Program.new("e", opcodes)

return_value = nil

max = [[9, 8, 7, 6, 5]].map do |a, b, c, d, e|
  a_program.reset
  b_program.reset
  c_program.reset
  d_program.reset
  e_program.reset

  a_input = [a, 0]
  b_input = [b]
  c_input = [c]
  d_input = [d]
  e_input = [e]

  p(a: a_input, b: b_input, c: c_input, d: d_input, e: e_input)
  loop do
    output = a_program.execute(a_input)
    b_input << output.last
    p(a: a_input, b: b_input, c: c_input, d: d_input, e: e_input)

    output = b_program.execute(b_input)
    c_input << output.last
    p(a: a_input, b: b_input, c: c_input, d: d_input, e: e_input)

    output = c_program.execute(c_input)
    d_input << output.last
    p(a: a_input, b: b_input, c: c_input, d: d_input, e: e_input)

    output = d_program.execute(d_input)
    e_input << output.last
    p(a: a_input, b: b_input, c: c_input, d: d_input, e: e_input)

    ouptut = e_program.execute(e_input)
    if output.first == :terminate
      break return_value
    else
      return_value = output.last
      p ["RETURN", return_value]
      a_input << return_value
    end
    p(a: a_input, b: b_input, c: c_input, d: d_input, e: e_input)
  end
end.max

puts "X"
p ["MAX", max]
