input = ARGF.read

smallest = input.chars.each_slice(25 * 6).min_by { |slice| slice.count("0") }

p smallest.count("1") * smallest.count("2")
