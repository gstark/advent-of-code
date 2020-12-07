rules = STDIN.read.split("\n")

# Take the trailing . to make parsing easier
# Split the bag from the bag contents
# Then take the pair (each_cons(2))
# And turn that into the bag name and an array of the contents
# where we pluralize any singular bag names and then convert counts to intengers
#
# Yes, this is overly compact to get it to one line
bag_details = rules.map { |rule| rule.chomp(".").split(" contain ").each_cons(2).flat_map { |bag_name, detail| [bag_name, detail.gsub(/bag$|bag([^s])/, 'bags\1').split(", ").flat_map { |content| content.scan(/(\d+) (.*)/) }.map { |count, bag| [count.to_i, bag] }] } }.to_h

def contains_gold(bag_details, bag_name)
  bag_details[bag_name].any? { |count, bag| bag.include?("shiny gold bag") || contains_gold(bag_details, bag) }
end

p bag_details.keys.count { |bag| contains_gold(bag_details, bag) }
