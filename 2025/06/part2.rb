lines = $stdin.readlines

column_ranges = lines
  # The last line is the operators
  .last
  # Scan for operators (+, *, newline) and get their positions. Using enum_for
  # lets us iterate over matches while Regexp.last_match still has the match info
  .enum_for(:scan, /[+*\n]/).map { Regexp.last_match.begin(0) }
  # Loop through each consecutive pair of indexes
  .each_cons(2)
  # And turn that into a range
  .map { |a, b| Range.new(a, b - 2) }

# NOTE, in our sample column ranges will be: [0..2, 4..6, 8..10, 12..14]

# Go through all the lines
answer = lines
  # Turn the line into an array of strings based on the column ranges
  .map { |line| column_ranges.map { |range| line[range] } }
  #
  # NOTE, in the sample, we will have:
  #
  # [
  #   ["123", "328", " 51", "64 "],
  #   [" 45", "64 ", "387", "23 "],
  #   ["  6", "98 ", "215", "314"],
  #   ["*  ", "+  ", "*  ", "+  "]
  # ]
  .transpose
  #
  # NOTE: in the sample we will now have:
  #
  # [
  #   ["123", " 45", "  6", "*  "],
  #   ["328", "64 ", "98 ", "+  "],
  #   [" 51", "387", "215", "*  "],
  #   ["64 ", "23 ", "314", "+  "]
  # ]
  #
  .sum { |*numbers, operator|
    # Using the first row (["123", " 45", "  6", "*  "]) as an example
    numbers.map(&:chars)
      #
      # Now we will have [["1", "2", "3"], [" ", "4", "5"], [" ", " ", "6"]]
      #
      .transpose
      #
      # Now we will have [["1", " ", " "], ["2", "4", " "], ["3", "5", "6"]]
      #
      .map(&:join)
      #
      # Now we will have ["1  ", "24 ", "356"]
      #
      .map(&:to_i)
      #
      # Now we will have [1, 24, 356]
      #
      # Finally this does a sum/product of the array
      .reduce(&operator[0].to_sym)
  }

p answer

# 7858808482092
