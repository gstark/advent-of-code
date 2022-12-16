p ARGF.readline(chomp: true).chars.each_cons(4).with_index { |packet, index| break index + 4 if packet.uniq.count == 4 }
