require 'awesome_print'

ap File.
  readlines("input.txt", chomp: true).
  map(&:split).
  map { |action, amount| { action: action, amount: amount.to_i } }.
  reduce({ horizontal: 0, depth: 0 }) { |result, command| command[:action] == "forward" ? { horizontal: result[:horizontal] + command[:amount], depth: result[:depth] } : { horizontal: result[:horizontal], depth: result[:depth] + ( command[:action] == "down" ? 1 : -1) * command[:amount] } }.
  values.
  reduce(&:*)
