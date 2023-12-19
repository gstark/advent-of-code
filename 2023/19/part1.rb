workflows, parts = ARGF.read.split("\n\n")

workflows = workflows
  .split("\n")
  .map { |line| line.scan(/([a-z]+){(.*)}/).flatten }
  .map { |name, instructions| [name, instructions.split(",").map { |instruction| instruction.include?(":") ? instruction.split(":").yield_self { |code, destination| {code: code.scan(/(\w+)([<>])(\d+)/).flatten, destination:} } : {destination: instruction} }] }
  .map { |name, instructions| [name, instructions.each { |instruction| instruction[:code][-1] = instruction[:code][-1].to_i if instruction[:code] }] }
  .to_h

parts = parts
  .split("\n")
  .map { |line| line.gsub(/^{|}$/, "").split(",").map { |part| part.split("=") }.to_h.transform_values(&:to_i) }

def instruction_match?(instruction, part)
  return true if instruction[:code].nil?

  category, operation, value = instruction[:code]

  case operation
  when "<" then part[category] < value
  when ">" then part[category] > value
  else raise "Can't find #{operation}"
  end
end

answer = parts.sum do |part|
  destination = "in"

  while destination != "A" && destination != "R"
    instruction = workflows[destination].find { |instruction| instruction_match?(instruction, part) }
    destination = instruction[:destination]
  end

  (destination == "A") ? part.values.sum : 0
end
p answer
