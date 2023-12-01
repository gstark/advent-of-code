require 'set'

# class State
#   attr_accessor :ore_robots, :clay_robots, :obsidian_robots, :geode_robots
#   attr_accessor :ore, :clay, :obsidian, :geode
#   attr_accessor :ore_robot_cost
#   attr_accessor :clay_robot_cost
#   attr_accessor :obsidian_robot_cost_ore
#   attr_accessor :obsidian_robot_cost_clay
#   attr_accessor :geode_robot_cost_ore
#   attr_accessor :geode_robot_cost_obsidian

def process(ore_robots, clay_robots, obsidian_robots, geode_robots, ore, clay, obsidian, geode, day, total_geodes)
  if day > 24
    total_geodes << geode
    p total_geodes
    return
  end

  possible = [:nothing]

  possible << :geode if ore >= $geode_robot_cost_ore && obsidian >= $geode_robot_cost_obsidian
  possible << :obsidian if ore > $obsidian_robot_cost_ore && clay >= $obsidian_robot_cost_clay
  possible << :clay if ore >= $clay_robot_cost
  # possible << :ore if ore >= $ore_robot_cost

  p possible
  possible.each do |option|
    new_ore_robots, new_clay_robots, new_obsidian_robots, new_geode_robots, new_ore, new_clay, new_obsidian, new_geode = [ore_robots, clay_robots, obsidian_robots, geode_robots, ore, clay, obsidian, geode]

    case option
    when :geode
      new_ore -= $geode_robot_cost_ore
      new_obsidian -= $geode_robot_cost_obsidian
      new_geode_robots += 1
    when :clay
      new_ore -= $clay_robot_cost
      new_clay_robots += 1
    when :obsidian
      new_ore -= $geode_robot_cost_ore
      new_clay -= $obsidian_robot_cost_clay
      new_obsidian_robots += 1
    when :ore
      new_ore -= $geode_robot_cost_ore
    end

    new_ore += ore_robots
    new_clay += clay_robots
    new_obsidian += obsidian_robots
    new_geode += geode_robots
    process(new_ore_robots, new_clay_robots, new_obsidian_robots, new_geode_robots, new_ore, new_clay, new_obsidian, new_geode, day + 1, total_geodes)
  end
end

$ore_robot_cost = 4
$clay_robot_cost = 2
$obsidian_robot_cost_ore = 3
$obsidian_robot_cost_clay = 14
$geode_robot_cost_ore = 2
$geode_robot_cost_obsidian = 7

total_geodes = Set.new
process(1,0,0,0,0,0,0,0,1,total_geodes)
p total_geodes