require "set"

INSTRUCTIONS = STDIN.read.split("\n").map(&:split).map { |code, value| ({ code: code, value: value.to_i }) }

def evaluate(instructions)
  acc = 0
  ip = 0
  seen_ips = Set.new
  until seen_ips.include?(ip)
    seen_ips << ip
    case instructions[ip][:code]
    when "acc" then acc += instructions[ip][:value]
    when "jmp" then ip += instructions[ip][:value] - 1
    end
    ip += 1
  end

  acc
end

p evaluate(INSTRUCTIONS)
