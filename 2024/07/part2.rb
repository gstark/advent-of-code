def eval_equation(equation, operators)
  eval_equation = equation.dup
  eval_operators = operators.dup

  while eval_equation.size > 1
    total = 0

    a, b = eval_equation.shift(2)
    operator = eval_operators.shift

    total += case operator
    when "+" then a + b
    when "*" then a * b
    when "||" then "#{a}#{b}".to_i
    end

    eval_equation.unshift(total)
  end

  total
end

p $stdin
  .readlines(chomp: true)
  .map { |line| line.split(": ") }
  .map { |value, equation| [value.to_i, equation.split.map(&:to_i)] }
  .filter { |value, equation| ["+", "*", "||"].repeated_permutation(equation.size - 1).any? { |operators| value == eval_equation(equation, operators) } }
  .sum { |value, equation| value }
