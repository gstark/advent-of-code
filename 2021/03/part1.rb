require 'awesome_print'

reports = File.readlines("input.txt", chomp: true)


ap ([reports[0].length.times.map { |index| reports.count { |report| report[index] == "1" } > reports.length / 2 ? "1" : "0" }.join.to_i(2)] * 2).map.with_index { |number, index| index == 0 ? number : number ^  ("1" * reports[0].length).to_i(2) }.reduce(:*)

#   reports[0].length.times.map { |index| reports.count { |report| report[index] == "1" } > reports.length / 2 ? "1" : "0" }.join.to_i(2) ^ ("1" * reports[0].length).to_i(2),
# ].reduce(:*)
