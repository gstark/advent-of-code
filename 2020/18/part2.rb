def infix_eval(infix)
  eval_stack = []
  while infix.any?
    token = infix.shift
    case token
    when Integer
      eval_stack << token
    when "+"
      eval_stack << (eval_stack.pop + eval_stack.pop)
    when "*"
      eval_stack << (eval_stack.pop * eval_stack.pop)
    end
  end

  eval_stack.first
end

def postfix_to_infix(postfix)
  infix = []
  stack = []

  postfix.chars.each.with_index do |token, index|
    case token
    when /\d/
      infix.push(token.to_i)
    when /[+*]/
      unless stack.any? && ["*", "("].include?(stack.last)
        infix << stack.pop while (stack.last == "+")
      end
      stack << token
    when "("
      stack << token
    when ")"
      while stack.last != "("
        infix << stack.pop
      end
      stack.pop
    end
  end

  infix << stack.pop while stack.any?

  infix
end

# p infix_eval(postfix_to_infix("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2"))
# p infix_eval(postfix_to_infix("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))"))

p STDIN.readlines.sum { |line| infix_eval(postfix_to_infix(line)) }
