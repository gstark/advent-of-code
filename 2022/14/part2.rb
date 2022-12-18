require "set"

paths = ARGF.readlines(chomp: true)

cave = {}

def render_cave_line(x1, y1, x2, y2, cave)
  Range.new(*[x1, x2].sort).each do |x|
    Range.new(*[y1, y2].sort).each do |y|
      cave[[x, y]] = "#"
    end
  end
end

paths.each do |path|
  path.split(" -> ").each_cons(2).map do |a, b|
    x1, y1 = a.split(",").map(&:to_i)
    x2, y2 = b.split(",").map(&:to_i)

    render_cave_line(x1, y1, x2, y2, cave)
  end
end

max_depth = cave.keys.map { |(x, y)| y }.max

# Render a line, not quite infinite, but infinite enough...
render_cave_line(0, max_depth + 2, 9999, max_depth + 2, cave)

drop_count = (0..).find do
  sand = [500, 0]

  loop do
    if cave[[sand[0], sand[1] + 1]].nil?
      sand = [sand[0], sand[1] + 1]
    elsif cave[[sand[0] - 1, sand[1] + 1]].nil?
      sand = [sand[0] - 1, sand[1] + 1]
    elsif cave[[sand[0] + 1, sand[1] + 1]].nil?
      sand = [sand[0] + 1, sand[1] + 1]
    else
      cave[[sand[0], sand[1]]] = "o"
      break
    end

    break if cave[[500, 0]] == "o"
  end

  cave[[500, 0]] == "o"
end

p drop_count + 1
