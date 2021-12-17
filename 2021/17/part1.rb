# x=150..193, y=-136..-86   input
# x=20..30, y=-10..-5       sample

target_x = (150..193)    # input
target_y = (-136..-86)   # input

# target_x = (20..30)      # sample
# target_y = (-10..-5)     # sample

MAX_VELOCITY = 200
ITERATIONS_TO_CHECK = 900

velocities = (1..MAX_VELOCITY).map { |vx| (1..MAX_VELOCITY).map { |vy| [vx, vy] } }.flatten(1)

max_y = velocities.map do |(ivx,ivy)|
  vx = ivx
  vy = ivy

  x = 0
  y = 0
  max_y = 0

  found = ITERATIONS_TO_CHECK.times.find_index do
    x += vx
    y += vy

    # Track max y
    max_y = [max_y, y].max

    # Drag x
    case
    when vx < 0 then vx += 1
    when vx > 0 then vx -= 1
    end

    # Gravity Y
    vy -= 1

    # Stop if we have gone too far
    break false if x > target_x.last || y < target_y.first

    # Stop if we are in the landing zone
    break true if target_x.cover?(x) && target_y.cover?(y)
  end

  [found, ivx, ivy, max_y]
end.select { |(found, ivx, ivy, max_y)| found }.max_by { |(found, ifx, ivy, max_y)| max_y }.last

p max_y