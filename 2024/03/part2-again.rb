p $stdin
    .readlines(chomp: true)
    .join("")
    .gsub(/don't\(\).*?do\(\)/, "") 
    .scan(/mul\((\d+),(\d+)\)/)
    .sum { |a, b| a.to_i * b.to_i }
