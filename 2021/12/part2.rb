require 'awesome_print'

paths = $stdin
          .read
          .split("\n")
          .map { |line| line.split("-") }
          .each
          .with_object({}) { |(from,to),hash|
            (hash[from] ||= []) << to unless to == "start"
            (hash[to] ||= []) << from unless from == "start"
          }

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
    # We can revisit any lower case spot we've seen as long as we haven't visited any spot twice
    when visited.tally.values.all? { |count| count == 1 }
      count_paths(paths, hop, [*visited, hop])
    # Otherwise this is the end of the road...
    else
      0
    end
  }
end

p count_paths(paths, "start")