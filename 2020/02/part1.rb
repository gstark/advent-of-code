passwords = STDIN.read.split("\n").map { |line| line.scan(/(\d+)-(\d+) ([a-z]): (\w+)/).flatten }

p passwords.count { |(min, max, letter, word)| word.count(letter).between?(min.to_i, max.to_i) }
