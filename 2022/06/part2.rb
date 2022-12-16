p ARGF.readline(chomp: true).chars.each_cons(14).with_index { |packet, index| break index + 14 if packet.uniq.count == 14 }
