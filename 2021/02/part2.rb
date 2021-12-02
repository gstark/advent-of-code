require 'awesome_print'

ACTIONS = {
  "forward" => proc { |command, result| { **result, horizontal: result[:horizontal] + command[:amount], depth: result[:depth] + result[:aim] * command[:amount] } },
  "down" => proc { |command, result| { **result, aim: result[:aim] + command[:amount] } },
  "up" => proc { |command, result| { **result, aim: result[:aim] - command[:amount] } }
}

ap File.
  readlines("input.txt", chomp: true).
  map(&:split).
  map { |action, amount| { action: action, amount: amount.to_i } }.
  reduce({ horizontal: 0, depth: 0, aim: 0 }) { |result, command| ACTIONS[command[:action]].call(command, result) }.
  delete_if { |action, value| action == :aim }.
  values.
  reduce(&:*)
