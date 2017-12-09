lines = File.readlines("05-input.txt").map(&:to_i)

pc = 0
steps = 0
while pc < lines.count do
  offset = lines[pc]
  lines[pc] += 1
  pc += offset
  steps += 1
end

p steps
