NUMBERS = STDIN.read.split("\n").map(&:to_i)

TARGET = 217430975
# NUMBERS.reverse_each.with_index do |number, index|
#   sum = 0
#   (0..index).each do |offset|
#     sum += NUMBERS[index - offset]
#     if sum == TARGET && offset > 1
#       p NUMBERS[index - offset..index].minmax.sum
#       exit
#     end
#     break if sum > TARGET
#   end
# end

(0..NUMBERS.length).each do |index|
  (1..index).each do |offset|
    range = NUMBERS[index - offset..index]
    if TARGET == range.sum
      p range.minmax.sum
      exit
    end
  end
end
