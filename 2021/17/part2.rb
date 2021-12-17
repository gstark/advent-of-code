# x=150..193, y=-136..-86   input
# x=20..30, y=-10..-5       sample

target_x = (150..193)    # input
target_y = (-136..-86)   # input

# target_x = (20..30)      # sample
# target_y = (-10..-5)     # sample

# Can't be any faster than moving beyond the target in one step
MAX_VELOCITY = [target_x.begin, target_x.end, target_y.begin, target_y.end].map(&:abs).max

velocities = (0..MAX_VELOCITY).map { |vx| (-MAX_VELOCITY..MAX_VELOCITY).map { |vy| [vx, vy] } }.flatten(1)

p velocities.select { |(vx,vy)|
  x = 0
  y = 0

  loop do
    # Stop if we have gone too far
    break false if x > target_x.last || y < target_y.first

    # Stop if we are in the landing zone
    break true if target_x.cover?(x) && target_y.cover?(y)

    x += vx
    y += vy

    # Drag x
    case
    when vx < 0 then vx += 1
    when vx > 0 then vx -= 1
    end

    # Gravity Y
    vy -= 1
  end
}.size