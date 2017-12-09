p File.read("04-input.txt").split("\n").count { |line| line.split(" ").group_by(&:itself).values.all? { |value| value.length == 1 } }
