chunks = $stdin
  .read
  .chars
  .map(&:to_i)
  .each_slice(2)
  .map { |file, free| [file.to_i, free.to_i] }
  .flat_map
  .with_index { |(file, free), index| [index] * file + ["."] * free }
  .chunk_while { |a, b| a == b }
  .to_a

(chunks.length - 1).downto(0) do |index|
  # puts chunks.join
  chunk = chunks[index]
  next if chunk[0] == "."

  free_space = chunks.find_index { |find_chunk| find_chunk[0] == "." && find_chunk.length >= chunk.length }
  next unless free_space
  next if free_space > index

  free_space_remaining = chunks[free_space].length - chunk.length

  chunks[free_space] = chunk
  chunks[index] = ["."] * chunk.length

  if free_space_remaining > 0
    chunks.insert(free_space + 1, ["."] * free_space_remaining)
    redo
  end
end

p chunks.flatten.map.with_index { |spot, index| (spot == ".") ? 0 : spot * index }.sum
