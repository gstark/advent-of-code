require 'awesome_print'

lines = $stdin.read.split("\n").map(&:chars)

PAIRS = {
  "(" => ")",
  "{" => "}",
  "<" => ">",
  "[" => "]"
}

POINTS = {
  ")" => 3,
  "]" => 57,
  "}" => 1197,
  ">" => 25137
}

ap lines.map { |line|
     line.each.with_object({stack: [], illegal: nil}) { |character, result|
       if result[:illegal]
         # Nothing
       elsif PAIRS[character]
         result[:stack].push(character)
       elsif PAIRS[result[:stack].last] == character
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