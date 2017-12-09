p File.read("04-input.txt").split("\n").count { |line| line.split(" ").group_by { |value| value.chars.sort.join }.values.all? { |value| value.length == 1 } }
