line = File.read("09-input.txt")

sum = 0
line.gsub(/!./, "").gsub(/<.*?>/) { |sequence| sum += (sequence.length - 2 ) }

p sum
