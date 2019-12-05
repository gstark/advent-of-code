# Get all the modules as integers
modules = ARGF.readlines.map(&:to_i)

# Ruby division between two integers is truncation so simply
# turn each module value into integer division by three and
# subtract two, then total those values
puts modules.sum { |_module| _module / 3 - 2 }
