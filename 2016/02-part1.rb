index = (1..9).to_enum
pad   = (-1..1).flat_map { |dx| (-1..1).map { |dy| [{x: dx, y: dy}, index.next] } }.to_h

position = { x: 0, y: 0 }

STDIN.readlines.map do |line|
  line.chomp.chars.each do |instruction|
    case instruction
    when 'U' then position[:x] = (position[:x] - 1).clamp(-1,1)
    when 'D' then position[:x] = (position[:x] + 1).clamp(-1,1)
    when 'L' then position[:y] = (position[:y] - 1).clamp(-1,1)
    when 'R' then position[:y] = (position[:y] + 1).clamp(-1,1)
    end
  end
  puts pad[position]
end
