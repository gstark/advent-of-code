forrest = STDIN.read.split("\n").map { |line| line.chars }

offset = 0
answer = forrest.each.with_index.count do |line, index|
  hit = index > 0 && line[offset] == "#"
  offset = (offset + 3) % line.length
  hit
end

p answer
