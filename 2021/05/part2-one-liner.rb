p STDIN.read.split("\n").map { |line| line.split("->").map { |parts| parts.split(",").map(&:to_i) } }.each.with_object({}) { |((x1,y1),(x2,y2)), hash| (x1 == x2 ? [x1] * (1 + (y1-y2).abs) : (x1..x2).step(x1 > x2 ? -1 : 1)).zip((y1 == y2 ? [y1] * (1 + (x1-x2).abs) : (y1..y2).step(y1 > y2 ? -1 : 1))).each { |position| hash[position] = (hash[position] || 0) + 1 } }.values.count { |value| value > 1 }


