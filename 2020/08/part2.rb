require "set"
require "json"

INSTRUCTIONS = STDIN.read.split("\n").map(&:split).map { |code, value| ({ code: code, value: value.to_i }) }

def evaluate(instructions)
  acc = 0
  ip = 0
  seen_ips = Set.new
  until seen_ips.include?(ip)
    seen_ips << ip
    case instructions[ip]["code"]
    when "acc" then acc += instructions[ip]["value"]
    when "jmp" then ip += instructions[ip]["value"] - 1
    end
    ip += 1
    return [true, acc] if ip >= instructions.length
  end

  return [false, acc]
end

INSTRUCTIONS.each.with_index do |instruction, index|
  new_instructions = JSON.parse(INSTRUCTIONS.to_json)

  case instruction[:code]
  when "nop" then new_instructions[index]["code"] = "jmp"
  when "jmp" then new_instructions[index]["code"] = "nop"
  else next
  end

  halts, acc = evaluate(new_instructions)
  p acc and break if halts
end
