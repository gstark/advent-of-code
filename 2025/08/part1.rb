points = ARGF.readlines(chomp: true).map { |line| line.split(",").map(&:to_i) }

def distance(point1, point2)
  Math.sqrt((point1[0] - point2[0])**2 + (point1[1] - point2[1])**2 + (point1[2] - point2[2])**2)
end

size = (points.length > 30) ? 1000 : 10

COMBOS = points
  .combination(2)
  .map { |point1, point2| [[point1, point2], distance(point1, point2)] }
  .sort_by { _2 }
  .take(size)

circuits = []
COMBOS.each.with_index do |combo, index|
  points = combo[0]
  _distance = combo[1]
  left = points[1]
  right = points[0]

  left_circuit_index = circuits.find_index { |circuit| circuit.include?(left) }
  right_circuit_index = circuits.find_index { |circuit| circuit.include?(right) }

  if left_circuit_index && right_circuit_index && left_circuit_index == right_circuit_index
    # both points are in the same circuit
    # do nothing
  elsif left_circuit_index && !right_circuit_index
    # left side is in a circuit and the right is in none
    # add the right to the left circuit
    circuits[left_circuit_index] << right
  elsif right_circuit_index && !left_circuit_index
    # right side is in a circuit and the left is in none
    # add the left to the right circuit
    circuits[right_circuit_index] << left
  elsif left_circuit_index && right_circuit_index && left_circuit_index != right_circuit_index
    # one side is in a circuit and the other is in a different circuit
    # Merge the two circuits
    circuits << [*circuits[left_circuit_index], *circuits[right_circuit_index]]
    [left_circuit_index, right_circuit_index].sort.reverse_each { |index| circuits.delete_at(index) }
  elsif left_circuit_index.nil? && right_circuit_index.nil?
    # Neither side is in a circuit
    # so create a new circuit
    circuits << Set.new([left, right])
  else
    raise "oops"
  end
end

p circuits.map(&:size).sort.last(3).inject(:*)
