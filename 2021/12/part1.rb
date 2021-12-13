require 'awesome_print'

paths = $stdin
          .read
          .split("\n")
          .map { |line| line.split("-") }
          # Turn each from/to pair into a pair of from/to and to/from
          .map { |from, to| [[from,to], [to,from]] }
          # And flatten this one level so we have an array of [ from/to, to/from, from/to, to/from, ...]
          .flatten(1)
          # And remove anything that takes us back to the start
          .reject { |from, to| to == "start"}
          # And turn this into a lookup map
          .each.with_object({}) { |(from,to),hash| (hash[from] ||= []) << to }

def count_paths(paths, location, visited = [])
  paths[location].sum { |hop|
    case
    # This is a hop to the end, so count it as 1
    when hop == "end"
      1
    # Can always revisit uppercase locations
    when hop.upcase == hop
      count_paths(paths, hop, [*visited])
    # We can revisit any lower case spot we haven't seen
    when visited.count(hop) == 0
      count_paths(paths, hop, [*visited, hop])
    # Otherwise this is the end of the road...
    else
      0
    end
  }
end

p count_paths(paths, "start")