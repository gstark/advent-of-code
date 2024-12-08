def eval_equation(value, equation)
  return value == equation[0] if equation.size == 1

  eval_equation(value, [equation[0] + equation[1], *equation[2..]]) ||
    eval_equation(value, [equation[0] * equation[1], *equation[2..]])
end

p $stdin
  .readlines(chomp: true)
  .map { |line| line.split(": ") }
  .map { |value, equation| [value.to_i, equation.split.map(&:to_i)] }
  .filter { |value, equation| eval_equation(value, equation) }
  .sum { |value, equation| value }
