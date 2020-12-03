passwords = STDIN.read.split("\n").map { |line| line.scan(/(\d+)-(\d+) ([a-z]): (\w+)/).flatten }

p passwords.count { |(first, second, letter, word)| 1 == [word[first.to_i - 1], word[second.to_i - 1]].count(letter) }
