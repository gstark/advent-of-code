$instructions = STDIN.take_while { |line| line != "\n" }.map do |line|
  _, number, rule = line.match(/(\d+): (.*)/).to_a
  [number, rule]
end.to_h

def to_expression(rule)
  case $instructions[rule]
  when /^(\d+) (\d+) \| (\d+) (\d+)$/
    ["(", [[to_expression($1), to_expression($2)].join, [to_expression($3), to_expression($4)].join].join("|"), ")"].join
  when /^(\d+) \| (\d+) (\d+)$/
    ["(", [[to_expression($1)].join, [to_expression($2), to_expression($3)].join].join("|"), ")"].join
  when /^(\d+) \| (\d+)$/
    ["(", [to_expression($1), to_expression($2)].join("|"), ")"].join
  when /"([ab])"/
    $1
  else
    $instructions[rule].scan(/\d+/).map { |subrule| to_expression(subrule) }.join
  end
end

expression = to_expression("0")
p expression
regexp = Regexp.new("^" + expression + "$")

p STDIN.readlines(chomp: true).select { |line| regexp.match?(line) }.length
