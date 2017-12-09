lines = File.readlines("08-input.txt")

registers = Hash.new { |k,v| k[v] = 0 }

lines.each do |line|
  register, inc_dec, value, _if, condition_register, operator, condition_value = line.split
  value = value.to_i
  condition_value = condition_value.to_i

  result = case operator
           when ">"
             registers[condition_register] > condition_value
           when "<"
             registers[condition_register] < condition_value
           when "<="
             registers[condition_register] <= condition_value
           when ">="
             registers[condition_register] >= condition_value
           when "=="
             registers[condition_register] == condition_value
           when "!="
             registers[condition_register] != condition_value
           else
             raise operator
           end

  if result
    registers[register] += (inc_dec == "inc" ? 1 : -1) * value
  end
end

p registers.values.max
