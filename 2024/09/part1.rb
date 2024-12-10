disk_map = $stdin.read.chars.map(&:to_i).each_slice(2).map { |file, free| [file.to_i, free.to_i] }

disk = disk_map.flat_map.with_index { |(file, free), index| [index] * file + [:free] * free }

free_spaces = disk.each.with_index.map { |spot, index| (spot == :free) ? index : nil }.compact

(disk.length - 1).downto(0) do |index|
  spot = disk[index]
  next if spot == :free

  free_space = free_spaces.shift

  if free_space && free_space < index
    disk[free_space] = spot
    disk[index] = :free

    free_spaces.push(index)
  end
end

p disk.map.with_index { |spot, index| (spot == :free) ? 0 : spot * index }.sum
