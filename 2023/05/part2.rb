seeds = STDIN.readline.split(":").last.split.map(&:to_i).each_slice(2).map { |start, length| start..(start+length-1) }

maps = STDIN
  .readlines(chomp: true)
  .chunk_while { |a,b| b != "" }
  .map { |lines| lines[2..].map(&:split).map { |dest, source, length| [source.to_i..source.to_i+length.to_i-1, dest.to_i - source.to_i]} }

p maps.reduce(seeds) { |working, ranges|
  working.flat_map { |working_range|
    ranges.
      # Find all ranges that overlap working range
      filter { |(range, offset)| range.include?(working_range.begin) || working_range.include?(range.begin) }.
      # Then process them. If there are no overlaps the whole range propagates, otherwise we have to take the correct slice, offset by the right amount
      yield_self { |overlaps| overlaps.empty? ? working_range : overlaps.flat_map { |(range, offset)|
        # Go through the overlaps for the different styles of overlaps we could have
        # based on the range and the range from the "working" array
        case
        # rb wrb re  wre
        # 10 11  12  13
        when range.begin <= working_range.begin && range.end <= working_range.end then working_range.begin+offset..range.end+offset-1

        # rb wrb wre re
        # 10 11  12  13
        when range.begin <= working_range.begin && range.end >= working_range.end then working_range.begin+offset..working_range.end+offset-1

        # wrb rb wre re
        # 10  11 12  13
        when range.begin >= working_range.begin && range.end >= working_range.end then range.begin+offset..working_range.end+offset-1

        # wrb rb re wre
        # 10  11 12 13
        when range.begin >= working_range.begin && range.end <= working_range.end then range.begin+offset..range.end+offset-1
        end
      }
    }
  }
}.map(&:first).min
# find the start of the smallest range
