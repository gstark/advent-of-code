require 'awesome_print'

# Turn the input into a hash of (r,c) => energy level
octo = $stdin
         .read
         .split("\n")
         .map(&:chars)
         .map
         .with_index { |row, row_index| row.map.with_index { |col, col_index| [[row_index,col_index], col.to_i] } }
         .flatten(1)
         .to_h

def show_map(octo)
  puts octo.reduce([]) { |map, ((r,c), level)| (map[r] ||= [])[c] = level; map }.map { |row| row.join }.join("\n")
end

NEIGHBORS = [
  [-1,-1],  # Above left
  [-1,+0],  # Above
  [-1,+1],  # Above right

  [+0,-1],  # Left
  [+0,+1],  # Right

  [+1,-1],  # Below left
  [+1,+0],  # Below
  [+1,+1],  # Below right
]

# This enumerator yields a hash of
# {
#   octo: the current map of the world
#   flashes: the number of flashes seen
#   step: the current step number
# }
step_enumerator = Enumerator.new do |yielder|
  next_octo = octo.dup
  total_flashes = 0

  (1..).each do |step|
    # Increase everyone's level
    next_octo.transform_values!(&:succ)

    # Keep track of the octo's not yet flashed
    not_yet_flashed = next_octo.keys

    loop do
      # The new flashers are those that have not yet flashed this round who are now over level 9
      new_flashers = not_yet_flashed.select { |r,c| next_octo[[r,c]] > 9 }

      # Stop processing this step if there aren't any new flashers
      break if new_flashers.empty?

      # Remove these from the not yet flashed collection
      not_yet_flashed -= new_flashers

      # Increment all the levels of the neighbors if they exist
      new_flashers.each { |r,c| NEIGHBORS.each { |delta_r, delta_c| next_octo[[r + delta_r, c + delta_c]] +=1 if octo[[r + delta_r, c + delta_c]] } }

      # Increment the total flashes
      total_flashes += new_flashers.length
    end

    # Anyone over 9 is now a 0
    next_octo.transform_values! { |level| level > 9 ? 0 : level }

    yielder << { octo: next_octo, flashes: total_flashes, step: step}
  end
end

# Run 100 cycles of the enumerator
state = step_enumerator.take(100).last

show_map(state[:octo])
puts "Flashes: #{state[:flashes]}"
