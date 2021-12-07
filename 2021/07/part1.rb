require 'awesome_print'

positions = $stdin.read.split(",").map(&:to_i)

# 16,1,2,0,4,2,7,1,2,14

# Cost of moving all to 16
# 16 - 16 = 0
# 16 - 1  = 15
# 16 - 2  - 14
# ...
#
# Cost of moving all to 1
# 16 - 1 = 15
# 1  - 1 = 0
# 2  - 1 = 1
# ...

fuel_total = (positions.min..positions.max).map { |to| positions.sum { |from| (from - to).abs } }.min
ap fuel_total
