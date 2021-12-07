require 'awesome_print'

fishies = $stdin.read.split(",").map(&:to_i).tally

# Compute the number of zeros
# Add that to the number of 6's
# Take the number of 1s and make that the number of 0s
# Take the number of 2s and make that the number of 1s
# ...
# Take the number of 8s and make that the number of 7s
# Make the initial number of 0s the number of 8s

256.times do |index|
  count_of_zeros = fishies.delete(0) || 0

  fishies[7] = (fishies[7] || 0) + count_of_zeros

  (1..8).each do |timer|
    fishies[timer-1] = fishies[timer]
  end

  fishies[8] = count_of_zeros
end

ap fishies.values.compact.sum