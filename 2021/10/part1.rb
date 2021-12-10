require 'awesome_print'

lines = $stdin.read.split("\n").map(&:chars)

OPENS =  "({<[".chars
CLOSES = ")}>]".chars
POINTS = { ")" => 3, "]" => 57, "}" => 1197, ">" => 25137 }

ap lines.map { |line|
     line.reduce({stack: [], illegal: nil}) { |result, character|
       break result if result[:illegal]

       if CLOSES.include?(character) && CLOSES.index(character) == OPENS.index(result[:stack].last)
         result[:stack].pop
       elsif CLOSES.include?(character) && CLOSES.index(character) != OPENS.index(result[:stack].last)
         result[:illegal] = character
       else
         result[:stack] << character
       end

       result
     }[:illegal]
   }
   .compact
   .map(&POINTS)
   .sum