p $stdin
  .readlines(chomp: true)
  .chunk_while { |line| line != "" }
  .map(&:to_a)
  .yield_self { |rules, updates| [rules[0...-1], updates] }
  .yield_self { |rules, updates| [rules.map { |rule| rule.split("|").map(&:to_i) }, updates.map { |update| update.split(",").map(&:to_i) }] }
  .yield_self { |rules, updates| [rules.sort_by { |a, _| a }, updates] }
  .yield_self { |rules, updates| [rules, updates.reject { |update| update.all? { |page| rules.filter { |a, _| a == page }.all? { |a, b| !update.include?(b) || update.index(a) < update.index(b) } }}] }
  .yield_self { |rules, updates|
    updates.map { |update|
      update.tap { |new_update|
        rules.each { |a, b|
          ai = new_update.index(a)
          bi = new_update.index(b)

          if ai && bi && ai > bi
            new_update.delete_at(ai)
            new_update.insert(bi, a)
          end
        }
      }
    }
  }
  .sum { |update| update[update.length / 2] }
