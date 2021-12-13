require 'awesome_print'

def print_dots(dots)
  max_x = dots.map { |dot| dot[:x] }.max
  max_y = dots.map { |dot| dot[:y] }.max

  puts (0..max_y).map { |y| (0..max_x).map { |x| dots.include?({x: x, y: y}) ? "#" : "." }.join }
end

# Parse the input.
#
# We'll read the whole input, line by line.
#
# We'll consider each line and if it matches the dot pattern, we'll add it to the first element of
# the dots_and_folds array, otherwise if it matches the fold pattern, we'll add it to the second.
#
# Then we'll destructure that array to get our dots and folds
dots, folds = $stdin.read.split("\n").each.with_object([[], []]) { |line, dots_and_folds|
  case
  when line =~ /(\d+),(\d+)/
    dots_and_folds.first << {x: $1.to_i, y: $2.to_i }
  when line =~ /([xy])=(\d+)/
    dots_and_folds.last << [$1, $2.to_i]
  end
}

folds.each do |direction, offset|
  dots = direction == "y" ? dots.map { |dot| dot[:y] > offset ? { x: dot[:x], y: 2 * offset - dot[:y] } : dot }
                          : dots.map { |dot| dot[:x] > offset ? { x: 2 * offset - dot[:x], y: dot[:y] } : dot }
end

print_dots(dots)