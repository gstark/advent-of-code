require 'awesome_print'

SEGMENTS_TO_DIGITS = { "abcefg" => "0", "cf" => "1", "acdeg" => "2", "acdfg" => "3", "bcdf" => "4", "abdfg" => "5", "abdefg" => "6", "acf" => "7", "abcdefg" => "8", "abcdfg" => "9" }

ap $stdin.read.split("\n").sum { |input|
  line, digits = input.split(" | ")

  line = line.split.map(&:chars)
  digits = digits.split(" ")

  original_line = line.dup

  # A is the wiring if we remove the segments of the 3 segment display from the two segment display
  a = (line.find { |entry| entry.length == 3 } - line.find { |entry| entry.length == 2 }).first

  line.map! { |line| line - [a] }

  # E is the wiring if we consider four length segments find the only one the exists once
  e = line.select { |entry| entry.length == 4 }.flatten.tally.find { |k, v| v == 1 }.first

  line.map! { |entry| entry - [e] }

  # C is the wiring if we remove the segments of the two segment display from the three segment display
  c = (line.find { |entry| entry.length == 3} & line.find { |entry| entry.length == 2 }).first

  line.map! { |entry| entry - [c] }

  # F is the wiring of the one segment display
  f = (line.find { |entry| entry.length == 1 }).first

  line.map! { |entry| entry - [f] }

  # B is the wiring of the element that appears twice in the two segment displays
  b = line.select { |entry| entry.length == 2}.flatten.tally.find { |k,v| v == 2 }.first

  line.map! { |entry| entry - [b] }

  # Using the original four segment display, d is the element if remove b,c,f
  d = (original_line.find { |entry| entry.length == 4 } - [b,c,f]).first

  line.map! { |entry| entry - [d] }

  # G is whatever is left over
  g = line.find { |entry| entry.length == 1 }.first

  wiring_map = {
    a => "a",
    b => "b",
    c => "c",
    d => "d",
    e => "e",
    f => "f",
    g => "g",
  }

  digits.map { |digit| SEGMENTS_TO_DIGITS[digit.chars.map(&wiring_map).sort.join] }.join.to_i
}