require 'set'
require 'active_support/all' # for overlaps?

class DisjointRanges
  attr_reader :ranges

  def initialize
    @ranges = Set.new
  end

  def <<(range)
    new_ranges = Set.new
    @ranges.each do |old_range|
      if range.overlaps?(old_range)
        range = Range.new([old_range.begin, range.begin].min, [old_range.end, range.end].max)
      else
        new_ranges << old_range
      end
    end

    new_ranges << range
    @ranges = new_ranges
  end
end

lines = ARGF.readlines(chomp: true)

sensors = lines.map.with_index do |line, index|
  # Sensor at x=2, y=18: closest beacon is at x=-2, y=15
  sensor_x, sensor_y, beacon_x, beacon_y = line.scan(/Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)/).first.map(&:to_i)

  {number: index + 1, x: sensor_x, y: sensor_y, beacon_x: beacon_x, beacon_y: beacon_y}
end

# This is very slow, there must be a faster algorithm than
# simply scanning for a row that isn't completely full.
(0..4_000_000).each do |line|
  disjoint_range = DisjointRanges.new

  sensors.each do |sensor|
    distance = (sensor[:x] - sensor[:beacon_x]).abs + (sensor[:y] - sensor[:beacon_y]).abs

    delta_y = (line - sensor[:y]).abs
    if delta_y < distance
      half_width = distance - delta_y
      disjoint_range << Range.new([0, sensor[:x] - half_width].max, [4_000_000, sensor[:x] + half_width].min)
    end
  end

  if disjoint_range.ranges.size > 1
    y = line
    x = disjoint_range.ranges.first.end + 1
    p 4_000_000 * x + y
    break
  end
end
