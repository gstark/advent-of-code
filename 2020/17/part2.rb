space = {}

STDIN.readlines(chomp: true).each.with_index do |row, x|
  row.chars.each.with_index do |column, y|
    space[{ x: x, y: y, z: 0, a: 0 }] = "#" if column == "#"
  end
end

OFFSETS = (-1..1).flat_map { |x| (-1..1).flat_map { |y| (-1..1).flat_map { |z| (-1..1).map { |a| [x, y, z, a] } } } }.reject { |_| _.all?(0) }

6.times do
  min_x, max_x = space.map { |location, _| location[:x] }.minmax
  min_y, max_y = space.map { |location, _| location[:y] }.minmax
  min_z, max_z = space.map { |location, _| location[:z] }.minmax
  min_a, max_a = space.map { |location, _| location[:a] }.minmax

  min_x -= 1
  max_x += 1

  min_y -= 1
  max_y += 1

  min_z -= 1
  max_z += 1

  min_a -= 1
  max_a += 1

  new_space = {}
  (min_x..max_x).each do |x|
    (min_y..max_y).each do |y|
      (min_z..max_z).each do |z|
        (min_a..max_a).each do |a|
          count = OFFSETS.count { |dx, dy, dz, da| space[{ x: x + dx, y: y + dy, z: z + dz, a: a + da }] == "#" }
          if space[{ x: x, y: y, z: z, a: a }] == "#" && count.between?(2, 3)
            new_space[{ x: x, y: y, z: z, a: a }] = "#"
          end
          if space[{ x: x, y: y, z: z, a: a }].nil? && count == 3
            new_space[{ x: x, y: y, z: z, a: a }] = "#"
          end
        end
      end
    end
  end

  space = new_space
end

p space.size
