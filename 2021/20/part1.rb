require 'awesome_print'

algo = $stdin.gets(chomp: true)

$stdin.gets

image = $stdin.readlines(chomp: true).map(&:chars).map.with_index { |row, r| row.map.with_index { |cell,c| [[r,c], cell] } }.flatten(1).to_h

NEIGHBORS = [
  [-1,-1],
  [-1,+0],
  [-1,+1],

  [+0,-1],
  [+0,+0],
  [+0,+1],

  [+1,-1],
  [+1,+0],
  [+1,+1],
]

TO_BINARY = {
  "." => "0",
  "#" => "1"
}

# 5489

def process_image(algo, image)
  min_row, max_row = image.keys.map { |row, _| row }.minmax
  min_col, max_col = image.keys.map { |_, col| col }.minmax
  min_row -= 20
  max_row += 20
  min_col -= 20
  max_col += 20

  {}.tap do |new_image|
    (min_row..max_row).each do |row|
      (min_col..max_col).each do |col|
        index = (NEIGHBORS.map { |delta_row, delta_col| image.fetch([delta_row + row, delta_col + col], ".") }).map(&TO_BINARY).join.to_i(2)
        new_image[[row, col]] = algo[index]
      end
    end
  end
end

new_image = process_image(algo, process_image(algo, image))

min_row, max_row = new_image.keys.map { |row, _| row }.minmax
min_col, max_col = new_image.keys.map { |_, col| col }.minmax


(min_row..max_row).each do |row|
  (min_col..max_col).each do |col|
    print new_image[[row, col]]
  end
  puts "\n"
end

puts

p new_image.values.count("#")