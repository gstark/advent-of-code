require 'awesome_print'
require 'set'

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

# Keep track of all the flashes
all_flashes = []
step = (1..).find do |step|
  # Increase everyone's level
  octo.transform_values!(&:succ)

  # Keep track of who has flashed already
  already_flashed = []

  loop do
    # Get the keys of the elements with levels more then 9 then remove any that have already flashed this round
    new_flashers = octo
                     .select { |(r,c), level| level > 9 }
                     .keys - already_flashed

    # Stop processing this step if there aren't any new flashers
    break if new_flashers.empty?

    # Increment all the levels of the neighbors if they exist
    new_flashers.each do |r,c|
      [
        [r-1,c-1],  # Above left
        [r-1,c+0],  # Above
        [r-1,c+1],  # Above right

        [r+0,c-1],  # Left
        [r+0,c+1],  # Right

        [r+1,c-1],  # Below left
        [r+1,c+0],  # Below
        [r+1,c+1],  # Below right
      ].each { |r,c| octo[[r,c]] +=1 if octo[[r,c]] }
    end

    # Keep track of the new flashers
    already_flashed.concat(new_flashers)
    all_flashes.concat(new_flashers)
  end

  # Anyone over 9 is now a 0
  octo.transform_values! { |level| level > 9 ? 0 : level }

  octo.values.all?(&:zero?)
end

show_map(octo)
puts
puts step
puts
puts all_flashes.size