require 'awesome_print'

SEGMENTS_TO_DIGITS = { "abcefg" => "0", "cf" => "1", "acdeg" => "2", "acdfg" => "3", "bcdf" => "4", "abdfg" => "5", "abdefg" => "6", "acf" => "7", "abcdefg" => "8", "abcdfg" => "9" }


# a => 8
# c => 8

# d => 7
# g => 7

# f => 9
# b => 6
# e => 4

ap $stdin.read.split("\n").sum { |input|
  # Splits the input to the line and the list of digits
  line, digits = input.split(" | ")

  # Split the digits to compute by spaces
  digits = digits.split

  # Counts are the tally of the non space characters
  counts = line.gsub(/ /, "").chars.tally

  # Characters in the digit four (used to disambiguate a-vs-c and d-vs-g)
  characters_in_the_four = line.split(" ").find { |entry| entry.length == 4}.chars

  wiring_map = {
    # We knows these wirings directly!
    "f" => counts.rassoc(9).first,
    "b" => counts.rassoc(6).first,
    "e" => counts.rassoc(4).first,

    # Things counted 8 times are either an "a" or a "c", so figure out which one *ISN'T* in the 4, that is the "a"
    "a" => (counts.select { |k,v| v == 8 }.keys - characters_in_the_four).first,
    # Things counted 8 times are either an "a" or a "c", so figure out which one *IS* in the 4, that is the "c"
    "c" => (counts.select { |k,v| v == 8 }.keys & characters_in_the_four).first,
    
    # Things coutned 7 times are either "d" or "g", so figure out which one *IS* in the 4, that is the "g"
    "d" => (counts.select { |k,v| v == 7 }.keys & characters_in_the_four).first,
    # Things coutned 7 times are either "d" or "g", so figure out which one *ISN'T* in the 4, that is the "g"
    "g" => (counts.select { |k,v| v == 7 }.keys - characters_in_the_four).first,
  }.invert

  digits.map { |digit| SEGMENTS_TO_DIGITS[digit.chars.map(&wiring_map).sort.join] }.join.to_i
}