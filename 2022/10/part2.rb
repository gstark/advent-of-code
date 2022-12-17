instructions = ARGF.readlines(chomp: true)

class CRT
  attr_accessor :register, :cycle, :instructions, :strength, :screen

  def initialize(instructions)
    self.instructions = instructions
    self.register = 1
    self.cycle = 1
    self.strength = 0
    self.screen = ""
  end

  def draw
    screen << if (register - 1..register + 1).cover?((cycle - 1) % 40)
      "#"
    else
      "."
    end

    screen << "\n" if cycle % 40 == 0
  end

  def tick
    self.cycle += 1

    self.strength += cycle * register if (cycle - 20) % 40 == 0
  end

  def run
    instructions.each do |instruction|
      case instruction
      when "noop"
        draw
        tick
      when /addx ([+-]?\d+)/
        draw
        tick
        draw
        self.register += $1.to_i
        tick
      end
    end
  end
end

crt = CRT.new(instructions)
crt.run
puts crt.screen
puts crt.strength
