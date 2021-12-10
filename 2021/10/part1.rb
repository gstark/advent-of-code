require 'awesome_print'

lines = $stdin.read.split("\n").map(&:chars)

OPENS =  "({<[".chars
CLOSES = ")}>]".chars
POINTS = { ")" => 3, "]" => 57, "}" => 1197, ">" => 25137 }

ap lines.map { |line|
     line.each.with_object({stack: [], illegal: nil}) { |character, result|
       break result if result[:illegal]

       if OPENS.include?(character)
         result[:stack].push(character)
       elsif CLOSES.index(character) == OPENS.index(result[:stack].last)
         result[:stack].pop
       else
         result[:illegal] = character
       end
     }
   }
   .select { |result| result[:illegal] }
   .map { |result| result[:illegal] }
   .map(&POINTS)
   .sum