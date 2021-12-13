require 'awesome_print'

def print_dots(dots)
  max_x = dots.map { |dot| dot[:x] }.max
  max_y = dots.map { |dot| dot[:y] }.max

  puts (0..max_y).map { |y| (0..max_x).map { |x| dots.include?({x: x, y: y}) ? "#" : "." }.join }
end

dots, folds = $stdin.read.split("\n").chunk_while { |a,b| !b.empty? }.to_a

dots = dots.map { |dot| dot.split(",").map(&:to_i) }.map { |x,y| {x: x, y: y} }
folds = folds.reject(&:empty?).map { |fold| fold.gsub(/fold along /, "") }.map { |fold| fold.split("=") }.map { |direction, offset| [direction, offset.to_i]}

direction, offset = folds.first

folds.take(1).each do |direction, offset|
  dots = direction == "y" ? dots.map { |dot| dot[:y] > offset ? { x: dot[:x], y: 2 * offset - dot[:y] } : dot }.reject { |dot| dot[:y] == offset }
                          : dots.map { |dot| dot[:x] > offset ? { x: 2 * offset - dot[:x], y: dot[:y] } : dot }.reject { |dot| dot[:x] == offset }
end

puts dots.uniq.size
