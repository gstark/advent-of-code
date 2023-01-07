cubes = ARGF.readlines(chomp: true).map { |cube| {coords: cube.split(",").map(&:to_i), faces: 6} }

cubes.combination(2).each do |a, b|
  coords_a = a[:coords]
  coords_b = b[:coords]

  if coords_a[0] == coords_b[0] && coords_a[1] == coords_b[1] && (coords_a[2] - coords_b[2]).abs == 1
    a[:faces] -= 1
    b[:faces] -= 1
  end
  if coords_a[0] == coords_b[0] && (coords_a[1] - coords_b[1]).abs == 1 && coords_a[2] == coords_b[2]
    a[:faces] -= 1
    b[:faces] -= 1
  end
  if (coords_a[0] - coords_b[0]).abs == 1 && coords_a[1] == coords_b[1] && coords_a[2] == coords_b[2]
    a[:faces] -= 1
    b[:faces] -= 1
  end
end

p cubes.map { |a| a[:faces] }.sum
