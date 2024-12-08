def eval_equation(value, equation, index, total)
  return value == total if index == equation.size - 1

  eval_equation(value, equation, index + 1, total + equation[index + 1]) ||
    eval_equation(value, equation, index + 1, total * equation[index + 1]) ||
    eval_equation(value, equation, index + 1, "#{total}#{equation[index + 1]}".to_i)
end

p $stdin
  .readlines(chomp: true)
  .map { |line| line.split(": ") }
  .map { |value, equation| [value.to_i, equation.split.map(&:to_i)] }
  .filter { |value, equation| eval_equation(value, equation, 0, equation[0]) }
  .sum { |value, equation| value }
