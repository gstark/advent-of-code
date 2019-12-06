require "set"

input = ARGF.read

# input = %{COM)B
# B)C
# C)D
# D)E
# E)F
# B)G
# G)H
# D)I
# E)J
# J)K
# K)L}

orbits = input.split("\n").map { |orbit| orbit.split(")") }

objects = orbits.reduce(Set.new) { |set, (left, right)| set << left << right }
orbit_map = orbits.reduce(Hash.new) { |map, (left, right)| map[right] = left; map }

def objects_until_com(orbit_map, object, objects = [])
  return objects if object == "COM"

  objects_until_com(orbit_map, orbit_map[object], objects | [object])
end

p objects.sum { |object| objects_until_com(orbit_map, object).length }
