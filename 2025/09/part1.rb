require_relative "../../lib/grid"

points = ARGF.readlines.map { |line| line.split(",").map(&:to_i) }

p points.combination(2).map { |(p1x, p1y), (p2x, p2y)| ((p1x - p2x).abs + 1) * ((p1y - p2y).abs + 1) }.max
