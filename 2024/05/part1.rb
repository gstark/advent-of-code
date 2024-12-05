p $stdin
  .readlines(chomp: true)
  .chunk_while { |line| line != "" }
  .map(&:to_a)
  .yield_self { |rules, updates| [rules[0...-1], updates] }
  .yield_self { |rules, updates| [rules.map { |rule| rule.split("|").map(&:to_i) }, updates.map { |update| update.split(",").map(&:to_i) }] }
  .yield_self { |rules, updates| updates.filter { |update| update.all? { |page| rules .filter { |a, _| a == page }.all? { |a, b| !update.include?(b) || update.index(a) < update.index(b) } } } }
  .sum { |update| update[update.length / 2] }
