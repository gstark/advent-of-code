(input.chars.push(input[-1])).map(&:to_i).each_cons(2).select { |a,b| a == b }.map(&:first).sum
