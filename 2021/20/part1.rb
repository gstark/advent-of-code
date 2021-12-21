require 'awesome_print'

algo = $stdin.gets(chomp: true)

$stdin.gets

# Read in the map
image = $stdin.readlines(chomp: true).map(&:chars).map.with_index { |row, r| row.map.with_index { |cell,c| [[r,c], cell] } }.flatten(1).to_h

# but don't waste time recording the empty space
image.delete_if { |_,v| v == '.' }

NEIGHBORS = [
  [-1,-1], [-1,+0], [-1,+1],
  [+0,-1], [+0,+0], [+0,+1],
  [+1,-1], [+1,+0], [+1,+1],
]

TO_BINARY = {
  "." => "0",
  "#" => "1"
}

def process_image(algo, image, infinite_void_value)
  min_row, max_row, min_col, max_col = map_edges(image)

  {}.tap do |new_image|
    # We'll go through the entire map bounded by the edges but +/- 2 to pick up new elements on the edges
    (min_row-2..max_row+2).each do |row|
      (min_col-2..max_col+2).each do |col|
        # Compute the index of this element by looking at all the neighbors
        index = (NEIGHBORS.map { |delta_row, delta_col|
          value = image.fetch([delta_row + row, delta_col + col], ".")

          # If the neighbor is in the infinite void, just return our current infinite void value
          value == 'I' ? infinite_void_value : value
        }).map(&TO_BINARY).join.to_i(2)

        # Record any point that is *ON*, don't bother saving spaces that are off
        new_image[[row, col]] = algo[index] unless algo[index] == '.'
      end
    end
  end
end

# Wraps the image in an infinite void marker
def surround_by_infinite_void(image)
  # Use 10 as a border size to make sure nothing ever looks beyond our infinite void border
  border_size = 10

  # Remove any existing infinite void
  image.delete_if { |_, v| v == 'I' }

  min_row, max_row, min_col, max_col = map_edges(image)

  (min_row-border_size...min_row).each do |row|
    (min_col-border_size...max_col+border_size).each do |col|
      image[[row,col]] = 'I'
    end
  end
  (min_col-border_size...min_col).each do |col|
    (min_row-border_size...max_row+border_size).each do |row|
      image[[row,col]] = 'I'
    end
  end
  (max_row+1...max_row+border_size).each do |row|
    (min_col-border_size...max_col+border_size).each do |col|
      image[[row,col]] = 'I'
    end
  end
  (max_col+1...max_col+border_size).each do |col|
    (min_row-border_size...max_row+border_size).each do |row|
      image[[row,col]] = 'I'
    end
  end
end

# Find the current map's min/max row/col
def map_edges(image)
  on_keys = image.select { |_,v| v == '#' }.keys

  min_row, max_row = on_keys.map { |row, _| row }.minmax
  min_col, max_col = on_keys.map { |_, col| col }.minmax

  [min_row, max_row, min_col, max_col]
end

def print_map(image)
  min_row, max_row, min_col, max_col = map_edges(image)

  (min_row-5..max_row+5).each do |row|
    (min_col-5..max_col+5).each do |col|
      print image.fetch([row, col], '.')
    end
    puts "\n"
  end
end

new_image = image

# The infinite void will toggle between two values
even_infinite_void = algo[0]
odd_infinite_void = algo[even_infinite_void == '#' ? 9 : 0]

50.times do |index|
  p index

  surround_by_infinite_void(new_image)

  new_image = process_image(algo, new_image, index.even? ? odd_infinite_void : even_infinite_void)
end

print_map(new_image)
p new_image.values.count('#')