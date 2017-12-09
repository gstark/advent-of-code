banks = []

bank = File.read("06-input.txt").split(" ").map(&:to_i)

count = 0
index = loop do
  count += 1

  # Find the *first* index of the largest value
  max = bank.max
  start_index = bank.index(max)

  # Store and clear the value found there
  value = bank[start_index]
  bank[start_index] = 0

  # Loop around the bank, adding one until we've done this *value* times
  value.times do |i|
    bank[(start_index + i + 1) % bank.length] += 1
  end

  # Stop if we've seen this pattern before
  if banks.include?(bank)
    offset = banks.index(bank)
    puts "The length of the loop is #{count - offset - 1} - found after #{count} iterations"
    exit
  end

  # Otherwise, remember the pattern
  banks << bank.dup
end
