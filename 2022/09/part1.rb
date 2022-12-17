require 'set'

steps = ARGF.readlines(chomp: true).map { |line| line.scan(/(.) (\d+)/).first }

head = {r: 0, c: 0}
tail = {r: 0, c: 0}
tail_visits = Set.new

def board(head, tail)
  6.times do |r|
    6.times do |c|
      if (5 + head[:r] == r) && head[:c] == c
        print "H"
      elsif (5 + tail[:r] == r) && tail[:c] == c
        print "T"
      else
        print "."
      end
    end
    puts
  end
end

board(head, tail)

steps.each do |(direction, size)|
  size.to_i.times do
    head = case direction
    when "D" then {r: head[:r] + 1, c: head[:c]}
    when "U" then {r: head[:r] - 1, c: head[:c]}
    when "L" then {r: head[:r], c: head[:c] - 1}
    when "R" then {r: head[:r], c: head[:c] + 1}
    end

    tail = if ((tail[:r] - head[:r]).abs > 1 && (tail[:c] - head[:c]).abs >= 1) || ((tail[:r] - head[:r]).abs >= 1 && (tail[:c] - head[:c]).abs > 1)
      case direction
      when "D" then {r: head[:r] - 1, c: head[:c]}
      when "U" then {r: head[:r] + 1, c: head[:c]}
      when "L" then {r: head[:r], c: head[:c] + 1}
      when "R" then {r: head[:r], c: head[:c] - 1}
      end
    elsif (tail[:r] - head[:r]).abs > 1 && tail[:c] == head[:c]
      case direction
      when "D" then {r: head[:r] - 1, c: head[:c]}
      when "U" then {r: head[:r] + 1, c: head[:c]}
      end
    elsif (tail[:c] - head[:c]).abs > 1 && tail[:r] == head[:r]
      case direction
      when "L" then {r: head[:r], c: head[:c] + 1}
      when "R" then {r: head[:r], c: head[:c] - 1}
      end
    else
      tail
    end

    tail_visits << tail
  end
end

p tail_visits.size
