# 147  142  133  122   59
# 304    5    4    2   57
# 330   10    1    1   54
# 351   11   23   25   26
# 362  747  806--->   ...
#
#
# right  (1)
# up     (1)
#
# left   (2)
# down   (2)
# right  (3)
# up     (3)
#
# left   (4)
# down   (4)
# right  (5)
# up     (5)
#
# left   (6)
# down   (6)
# right  (7)
# up     (7)

map = {
  [0,0] => 1,
  [1,0] => 1,
  [1,1] => 2,
}

input = 312051
def update_map(direction, map, cursor)
  count = 0
  (-1..1).each do |dx|
    (-1..1).each do |dy|
      next if dx == 0 && dy == 0
      value = map[[cursor[0] + dx, cursor[1] + dy]]
      count += value if value
    end
  end
  map[cursor] = count
end

cursor = [1,1]
(2..1000000).step(2) do |step_size|
  # left
  step_size.times do
    cursor = [cursor[0] - 1, cursor[1]]
    update_map("left", map, cursor)
  end

  # down
  step_size.times do
    cursor = [cursor[0], cursor[1]-1]
    update_map("down", map, cursor)
  end

  # right
  (step_size + 1).times do
    cursor = [cursor[0]+1, cursor[1]]
    update_map("right", map, cursor)
  end

  # up
  (step_size + 1).times do
    cursor = [cursor[0], cursor[1]+1]
    update_map("up", map, cursor)
  end

  found = map.values.sort.find { |value| value > input }
  if found
    p found
    break
  end
end
