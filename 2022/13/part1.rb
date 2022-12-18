lists = ARGF.readlines(chomp: true).each_slice(3).map { |(a, b, _)| [eval(a), eval(b)] }

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

p lists.map.with_index { |(a, b), index| compare(a, b) ? index + 1 : 0 }.sum
