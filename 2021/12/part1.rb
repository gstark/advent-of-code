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

def count_paths(paths, from, to, only_visit_once = [])
  return 1 if from == to

  (paths.fetch(from, []) - only_visit_once).sum { |hop| count_paths(paths, hop, to, [*only_visit_once].concat(hop.downcase == hop ? [hop] : [])) }
end

p count_paths(paths, "start", "end")