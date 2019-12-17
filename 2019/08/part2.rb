input = ARGF.read

layers = input.chars.each_slice(25 * 6).to_a

image = (25 * 6).times.map { |index| layers.find { |layer| layer[index] != "2" }[index] }

image.each_slice(25).each { |row| puts row.join.gsub("0", " ") }
