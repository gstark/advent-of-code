require 'awesome_print'

lines = $stdin.read.split("\n").map(&:chars)

PAIRS = {
  "(" => ")",
  "{" => "}",
  "<" => ">",
  "[" => "]"
}

POINTS = {
  ")" => 1,
  "]" => 2,
  "}" => 3,
  ">" => 4
}

ap lines.map { |line|
     line.each.with_object({stack: [], illegal: nil}) { |character, result|
       break result if result[:illegal]

       if PAIRS[character]
         result[:stack].push(character)
       elsif PAIRS[result[:stack].last] == character
         result[:stack].pop
       else
         result[:illegal] = character
       end
     }
   }
   .reject { |result| result[:illegal] }
   .map { |result| result[:stack].reverse.map(&PAIRS) }
   .map { |line| line.reduce(0) { |total, character| total = total * 5 + POINTS[character] } }
   .sort
   .yield_self { |list| list[list.length/2] }
