def expression_value(expression)
  value = nil
  operand_stack = []
  operator_stack = []

  expression.chars.each.with_index do |token, index|
    case token
    when /\d/
      operand_stack.push(token.to_i)
    when /[+-\/*]/
      operator_stack.push(token)
    when "("
      operand_stack.push(token)
    when ")"
      value = operand_stack.pop
      operand_stack.pop
      operand_stack.push(value)
    end

    if operand_stack[-1] && operand_stack[-2] && operand_stack[-1] != "(" && operand_stack[-2] != "("
      a = operand_stack.pop.to_i
      b = operand_stack.pop.to_i
      operator = operator_stack.pop
      case operator
      when "+" then operand_stack.push(a + b)
      when "*" then operand_stack.push(a * b)
      end
    end
  end

  return operand_stack.pop
end

# p expression_value("2 * 3 + (4 * 5)") # becomes 26.
# p expression_value("5 + (8 * 3 + 9 + 3 * 4 * 3)") # becomes 437.
# p expression_value("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))") # becomes 12240.
# p expression_value("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2") # becomes 13632.

p STDIN.readlines(chomp: true).each { |line| line.gsub(/ /, "") }.sum { |line| expression_value(line) }
