$instructions = STDIN.take_while { |line| line != "\n" }.map do |line|
  _, number, rule = line.match(/(\d+): (.*)/).to_a
  [number, rule]
end.to_h

def to_expression(rule)
  if rule == "8"
    return ["(", to_expression("42"), ")", "+"].join
  end

  if rule == "11"
    # The rule is the number of times rule 42 applies matches the number of times 31 applies
    # I could not find a regexp way of expressing this, so I just matched
    # 1 time for each OR 2 times for each OR 3 times for each OR ....
    return "(" + (1..20).map { |repeat| ["(", "(", to_expression("42"), ")", "{#{repeat}}", "(", to_expression("31"), ")", "{#{repeat}}", ")"].join }.join("|") + ")"
  end

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
regexp = Regexp.new("^" + expression + "$")

p STDIN.readlines(chomp: true).select { |line| regexp.match?(line) }.length
