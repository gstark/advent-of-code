require "rgeo"

def rectangle(factory, p1x, p1y, p2x, p2y)
  x_min, x_max = [p1x, p2x].minmax
  y_min, y_max = [p1y, p2y].minmax

  rectangle_points = [
    factory.point(x_min, y_min),  # lower-left
    factory.point(x_max, y_min),  # lower-right
    factory.point(x_max, y_max),  # upper-right
    factory.point(x_min, y_max),  # upper-left
    factory.point(x_min, y_min)   # back to lower-left (close the ring)
  ]

  factory.polygon(factory.linear_ring(rectangle_points))
end

# Create a factory with GEOS support (required for within?)
factory = RGeo::Geos.factory
raise "GEOS not installed. Run: brew install geos" if factory.nil?

points = ARGF.readlines.map { |line| line.split(",").map(&:to_i) }

# Build up the floor
floor = factory.polygon(factory.linear_ring(points.map { |(x, y)| factory.point(x, y) }))

p points
  # Combine over all the points
  .combination(2)
  # Filter to just the rectangles inside the floor. Use p2x + 1 and p2y + 1 to
  # allow for the fact that a thin line of tiles would have the same x or y
  .filter { |(p1x, p1y), (p2x, p2y)| rectangle(factory, p1x, p1y, p2x + 1, p2y + 1).within?(floor) }
  # Now compute the area of the rectangle
  .map { |(p1x, p1y), (p2x, p2y)| ((p1x - p2x).abs + 1) * ((p1y - p2y).abs + 1) }
  # And return the max
  .max
