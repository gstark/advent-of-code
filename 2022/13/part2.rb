lists = ARGF.readlines(chomp: true).each_slice(3).flat_map { |(a, b, _)| [eval(a), eval(b)] }

def compare(a, b)
  if a.is_a?(Integer) && b.is_a?(Integer)
    (a == b) ? :keep_searching : a < b
  elsif a.is_a?(Array) && b.is_a?(Integer)
    compare(a, Array(b))
  elsif a.is_a?(Integer) && b.is_a?(Array)
    compare(Array(a), b)
  else
    final_result = :keep_searching 
    [a.length, b.length].min.times do |index|
      first = a[index]
      second = b[index]

      result = compare(first, second)
      unless result == :keep_searching
        final_result = result
        break
      end
    end

    if final_result != :keep_searching
      final_result
    elsif a.length == b.length
      :keep_searching
    else
      a.length < b.length
    end
  end
end

lists << [[2]]
lists << [[6]]

sorted = lists.sort { |a, b| compare(a, b) ? -1 : 1 }

p (sorted.index([[2]]) + 1) * (sorted.index([[6]]) + 1)
