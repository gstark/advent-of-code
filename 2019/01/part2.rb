# Get all the modules as integers
modules = ARGF.readlines.map(&:to_i)

# The amount of fuel is how much we need
# for the module (integer division by three, then minus two)
# or 0 if the value is negative. (This is what [__, 0].max does)
#
# If there is still an amount, recursively compute the amount
# plus how much fuel that will require, otherwise it is just
# the amount
def fuel(_module)
  amount = [_module / 3 - 2, 0].max

  amount > 0 ? amount + fuel(amount) : amount
end

puts modules.sum { |_module| fuel(_module) }
