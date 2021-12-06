require 'awesome_print'
# 0,9 -> 5,9

lines = STDIN.read.split("\n").map { |line| line.split("->").map { |parts| parts.split(",").map(&:to_i) } }

filtered_lines = lines

# 9,7 -> 7,9

# [9,8,7]    [7,8,9]
# 
# (9,7)
# (8,8)
# (7,9)

# ..........
# ..........
# ..........
# ..........
# ..........
# ..........
# ..........
# .........1
# ........1.
# .......1..




# Start with an empty hash of positions and counts
hash = {}
# Loop through our filtered lines
filtered_lines.each do |(x1,y1),(x2,y2)|
  # For each line
  #   loop through each position in that line
  case
  when x1 == x2
    y_range = [y1,y2].min .. [y1,y2].max
    x_range = [x1] * y_range.count

  when y1 == y2
    x_range = [x1,x2].min .. [x1,x2].max
    y_range = [y1] * x_range.count

  else # x1 != x2 && y1 != y2
    x_range = [x1,x2].min .. [x1,x2].max
    y_range = [y1,y2].min .. [y1,y2].max

    if x1 < x2
      x_range = x_range.to_a.reverse
    end

    if y1 < y2
      y_range = y_range.to_a.reverse
    end
  end

  x_range.zip(y_range).each do |position|
    hash[position] = (hash[position] || 0) + 1 
  end
end


# To get our answer count the number of values where the value is two or more
ap hash.values.count { |value| value > 1}




# 0,9    1,9   2,9    3,9    4,9    5,9

# 7,0 

# 7,1
# 7,2
# 7,3

# 7,4



