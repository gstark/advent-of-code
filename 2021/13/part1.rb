require 'ostruct'
require 'awesome_print'

def make_dot(x,y)
  OpenStruct.new(x: x, y: y)
end

def print_dots(dots)
  max_x = dots.map { |dot| dot[:x] }.max
  max_y = dots.map { |dot| dot[:y] }.max

  puts (0..max_y).map { |y| (0..max_x).map { |x| dots.include?(make_dot(x, y)) ? "#" : "." }.join }
end

dots = []
folds = []
$stdin.readlines.each do |line|
  case
  when line =~ /(\d+),(\d+)/  then dots << make_dot($1.to_i, $2.to_i)
  when line =~ /([xy])=(\d+)/ then folds << [$1, $2.to_i]
  end
end

folds.take(1).each do |direction, offset|
  dots = direction == "y" ? dots.map { |dot| dot.y > offset ? make_dot(dot.x, 2 * offset - dot.y) : dot }
                          : dots.map { |dot| dot.x > offset ? make_dot(2 * offset - dot.x, dot.y) : dot }
end

puts dots.uniq.size
