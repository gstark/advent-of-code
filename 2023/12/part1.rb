
def possible(line, needed_counts)
  first = line[0...line.index(/#+\?+#*|\?+/)]
  parts = first.scan(/#*/).reject(&:empty?).map(&:length)
  needed_parts = needed_counts.take(parts.length)
  answer = parts == needed_parts
  # puts "Testing if #{line} #{needed_counts} is possible (#{parts} = #{needed_parts}) => #{answer}"
  answer
end

def solve(line, needed_counts)
  # puts "Solving #{line}"
  index = line.index("?")

  if index.nil?
    scan = line.scan(/#*/).reject(&:empty?).map(&:length) == needed_counts
    # puts "End of the line: #{line} #{scan}"
    return scan ? 1 : 0
  end

  new_line = line.dup
  new_line[index] = "#"

  if possible(new_line, needed_counts)
    dot_line = line.dup
    dot_line[index] = "."
    # puts "#{line} -> #{new_line} and #{dot_line}"
    return solve(new_line, needed_counts) + solve(dot_line, needed_counts)
  else
    new_line = line.dup
    new_line[index] = "."
    return solve(new_line, needed_counts)
  end
end

answer = ARGF
  .readlines(chomp: true)
  .sum do |line, i|
    lava, needed_counts = line.split(' ')
    needed_counts = needed_counts.split(",").map(&:to_i)

    solve(lava, needed_counts)
  end

p answer