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
  dots << make_dot($1.to_i, $2.to_i) if line =~ /(\d+),(\d+)/  
  folds << [$1, $2.to_i] if line =~ /([xy])=(\d+)/
end

folds.each do |direction, offset|
  dots = direction == "y" ? dots.map { |dot| dot.y > offset ? make_dot(dot.x, 2 * offset - dot.y) : dot }
                          : dots.map { |dot| dot.x > offset ? make_dot(2 * offset - dot.x, dot.y) : dot }
end

print_dots(dots)