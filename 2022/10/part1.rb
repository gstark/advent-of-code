instructions = ARGF.readlines(chomp: true)

register = 1
cycle = 1
strength = 0

instructions.each do |instruction|
  case instruction
  when "noop"
    cycle += 1
    if (cycle - 20) % 40 == 0
      strength += cycle * register
    end
  when /addx ([+-]?\d+)/
    cycle += 1
    if (cycle - 20) % 40 == 0
      strength += cycle * register
    end
    register += $1.to_i
    cycle += 1
    if (cycle - 20) % 40 == 0
      strength += cycle * register
    end
  end
end

p strength