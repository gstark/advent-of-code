require "amazing_print"

hash = {}
STDIN.readlines(chomp: true).each do |line|
  food = line.split("(")[0].split(" ")
  alergens = line.split("(")[1].delete(")").gsub(/contains /, "").gsub(/ /, "").split(",")
  hash[alergens] ||= []
  hash[alergens] << food
end

foods_with_alergens = {}
while foods_with_alergens.keys.size < hash.keys.flatten.uniq.size
  all_alergens = hash.keys.flatten.uniq
  all_alergens.each do |alergen|
    foods = hash.select { |alergens, food| alergens.include?(alergen) }.values.flatten(1).reduce(:&)

    if foods.size == 1
      foods_with_alergens[alergen] = foods.first
      hash.each do |alergen, foods|
        hash[alergen] = foods.map { |_foods| _foods - foods_with_alergens.values }
      end
    end
  end
end

puts foods_with_alergens.sort.map { |alergen, food| food }.join(",")
