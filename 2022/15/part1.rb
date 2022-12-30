require 'set'
require 'active_support/all'

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

LINE = 2000000
# LINE = 10

disjoint_range = DisjointRanges.new

sensors.each do |sensor|
  distance = (sensor[:x] - sensor[:beacon_x]).abs + (sensor[:y] - sensor[:beacon_y]).abs

  delta_y = (LINE - sensor[:y]).abs
  if delta_y < distance
    half_width = distance - delta_y
    disjoint_range << Range.new(sensor[:x] - half_width, sensor[:x] + half_width)
  end
end

p disjoint_range.ranges.sum { |range| range.size } - 1
