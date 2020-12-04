passports = STDIN.read.split("\n\n").map { |line| line.split(/[ \n]/).map { |element| element.split(":") } }.map { |element| element.to_h }

KEYS = %w{byr iyr eyr hgt hcl ecl pid}
p passports.count { |passport| KEYS.all? { |key| passport.key?(key) } }
