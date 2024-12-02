p $stdin
  .each_line
  .map { |line| line.split.map(&:to_i) }
  # Now we have an array of arrays of numbers
  #
  # Count how many arrays (reports) have the following properties
  .count { |report|
    # Make an array with the original report, and all the variations of the report missing each of the indexes
    # The reject.with_index is a bit of a hack to generate the variations without each of the indexes.
    # Ruby doesn't have a built-in way. We could use `delete_at` but it doesn't have a friendly interface.
    #
    # Note the * in front of the (0...report.size) flattens out the generated map of values into the array.
    [report, *(0...report.size).map { |index| report.reject.with_index { |_, i| i == index } }]
      # Be true if *ANY* of the variations of the report have the following properties
      .any? { |report|
        report
          # Sort the report in the correct order
          .yield_self { |report| (report[1] > report[0]) ? report : report.reverse }
          # The report is valid if it is increasing and each subsequent pair of numbers is separated by a distance between 1 and 3
          .yield_self { |report| report.sort == report && report.each_cons(2).all? { |a, b| (b - a).between?(1, 3) } }
      }
  }
