_ = STDIN.gets.to_i
INPUT = STDIN.gets.split(",").map.with_index { |bus, index| [bus.to_i, index] }.reject { |bus, index| bus == 0 }

time = 0
step = 1

INPUT.each do |bus_id, mins|
  while (time + mins) % bus_id != 0
    time += step
    puts "For #{bus_id} considering #{time}"
  end

  step *= bus_id
  puts "Step is now #{step}"
end

p time
