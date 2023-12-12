answer = ARGF
  .readlines(chomp: true)
  .sum do |line, i|
    lava, needed_counts = line.split(' ')

    lava_count = lava.chars.count("?")
    (0..2**lava_count-1).count do |index|
      replacements = index.to_s(2).rjust(lava_count, '0').tr("10", "#.")

      needed_counts == line
        .gsub(/[?]/)
        .with_index { |_, position| replacements[position] }
        .scan(/#*/)
        .reject(&:empty?)
        .map(&:length)
        .join(",")
    end
  end

p answer