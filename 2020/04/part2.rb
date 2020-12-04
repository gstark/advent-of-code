passports = STDIN.read.split("\n\n").map { |line| line.split(/[ \n]/).map { |element| element.split(":") } }.map { |element| element.to_h }

VALIDATIONS = {
  "byr" => proc { |v| v.to_i.between?(1920, 2002) },
  "iyr" => proc { |v| v.to_i.between?(2010, 2020) },
  "eyr" => proc { |v| v.to_i.between?(2020, 2030) },
  "hgt" => proc { |v| v.match(/[0-9]+cm/) && v.to_i.between?(150, 193) || v.match(/[0-9]+in/) && v.to_i.between?(59, 76) },
  "hcl" => proc { |v| v.match(/^#[0-9a-f]{6}$/) },
  "ecl" => proc { |v| %w{amb blu brn gry grn hzl oth}.include?(v) },
  "pid" => proc { |v| v.match(/^[0-9]{9}$/) },
}

p passports.count { |passport| VALIDATIONS.keys.all? { |key| passport[key] && VALIDATIONS[key].call(passport[key]) } }
