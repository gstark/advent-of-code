require 'awesome_print'

fishies = $stdin.read.split(",").map(&:to_i)

# Count the number of 0s
256.times do |day|
  zero_fish = fishies.count(0)
  # For each fish in our list
  fishies.map! do |fish|
    # - Decrement the timer of each fish - If it is a 0 become a 6
    fish.zero? ? 6 : fish - 1
  end
  # Append `8`s to the end list for each `0` we counted
  fishies.concat([8] * zero_fish)
end

ap fishies.length
