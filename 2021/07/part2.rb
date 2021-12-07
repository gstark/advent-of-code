require 'awesome_print'

positions = $stdin.read.split(",").map(&:to_i)

#    Move from 16 to 5: 66 fuel
#    Move from 1 to 5: 10 fuel
#    Move from 2 to 5: 6 fuel
#    Move from 0 to 5: 15 fuel
#    Move from 4 to 5: 1 fuel
#    Move from 2 to 5: 6 fuel
#    Move from 7 to 5: 3 fuel
#    Move from 1 to 5: 10 fuel
#    Move from 2 to 5: 6 fuel
#    Move from 14 to 5: 45 fuel

# http://mathandmultimedia.com/2010/09/15/sum-first-n-positive-integers/

# cost from a to b   sum of 1..(a-b).abs
# 16 to 5 - 66    (16-5)
# 16 to 15 - 1
# 15 to 14 - 2
# 14 to 13 - 3
# 13 to 12 - 4
# 12 to 11 - 5
# 11 to 10 - 6
# 10 to  9 - 7
# 9  to  8 - 8
# 8  to  7 - 9
# 7  to  6 - 10
# 6  to  5 - 11


fuel_total = (positions.min..positions.max).map { |to| positions.sum { |from| (from - to).abs * ((from-to).abs + 1)/2 } }.min
ap fuel_total
