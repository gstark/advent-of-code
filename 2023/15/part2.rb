line = ARGF.read.chomp

hash = {}
line
  .split(",")
  .each do |instruction|
    label, operator, lens = instruction.scan(/([a-zA-Z]+)([-=])(.*)/).flatten

    box = label.chars.reduce(0) { |value, char| (value + char.ord) * 17 % 256 }

    hash[box] ||= {}

    case operator
    when "-" then hash[box].delete(label)
    when "=" then hash[box][label] = lens.to_i
    end
  end

p hash.sum { |box, contents| contents.each.with_index.sum { |(label, lens), index| (box + 1) * (index + 1) * lens } }
