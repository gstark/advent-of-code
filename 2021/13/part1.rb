require 'awesome_print'

def print_dots(dots)
  max_x = dots.map { |dot| dot[:x] }.max
  max_y = dots.map { |dot| dot[:y] }.max

  puts (0..max_y).map { |y| (0..max_x).map { |x| dots.include?({x: x, y: y}) ? "#" : "." }.join }
end

dots = []
folds = []
$stdin.readlines.each do |line|
  case
  when line =~ /(\d+),(\d+)/  then dots << { x: $1.to_i, y: $2.to_i }
  when line =~ /([xy])=(\d+)/ then folds << [$1, $2.to_i]
  end
end

folds.take(1).each do |direction, offset|
  dots = direction == "y" ? dots.map { |dot| dot[:y] > offset ? { x: dot[:x], y: 2 * offset - dot[:y] } : dot }
                          : dots.map { |dot| dot[:x] > offset ? { x: 2 * offset - dot[:x], y: dot[:y] } : dot }
end

puts dots.uniq.size
