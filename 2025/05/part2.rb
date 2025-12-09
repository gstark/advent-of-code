def merge_range(distinct_ranges, range)
  distinct_ranges.each do |distinct_range|
    next unless range.overlap?(distinct_range)

    distinct_ranges.delete(distinct_range)

    return merge_range(
      distinct_ranges,
      Range.new([range.begin, distinct_range.begin].min, [range.end, distinct_range.end].max)
    )
  end

  distinct_ranges << range
end

ranges, _ = $stdin.read.split("\n\n")

p ranges
  .split("\n")
  .map { |range| Range.new(*range.split("-").map(&:to_i)) }
  .reduce([], &method(:merge_range))
  .sum(&:size)
