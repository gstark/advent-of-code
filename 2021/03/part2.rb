require 'awesome_print'

reports = File.readlines("input.txt", chomp: true)

# Start with the entire list
# Start at index 0
# Filter the list based on the count of "1" or "0" in
#  the column based on the index
#  Keep only the entries that have the same bit as the most common value
#  if there is a tie, keep the "1"

def rating(array, bit_value_when_there_are_more_ones, bit_value_when_there_are_more_zeros)
  working_array = array.dup

  index = 0
  while working_array.length > 1
    to_keep = working_array.count { |report| report[index] == "1" } >= working_array.length / 2.0 ? bit_value_when_there_are_more_ones : bit_value_when_there_are_more_zeros
    working_array = working_array.select { |report| report[index] == to_keep }
    index += 1
  end

  working_array.first.to_i(2)
end

def oxygen_rating(reports)
  rating(reports, "1", "0")
end

def co2_rating(reports)
  rating(reports, "0", "1")
end

ap oxygen_rating(reports) * co2_rating(reports)
