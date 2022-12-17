require "set"

steps = ARGF.readlines(chomp: true).map { |line| line.scan(/(.) (\d+)/).first }

DELTAS = {
  [+0, +2] => [+0, +1],
  [+0, -2] => [+0, -1],
  [+2, +0] => [+1, +0],
  [-2, +0] => [-1, +0],

  [+1, +2] => [+1, +1],
  [+1, -2] => [+1, -1],

  [-1, +2] => [-1, +1],
  [-1, -2] => [-1, -1],

  [+2, +1] => [+1, +1],
  [-2, +1] => [-1, +1],

  [+2, -1] => [+1, -1],
  [-2, -1] => [-1, -1],

  [-2, +2] => [-1, +1],
  [-2, -2] => [-1, -1],
  [+2, +2] => [+1, +1],
  [+2, -2] => [+1, -1]
}

# Changing this to "2" makes this also
# solve for part 1.
ROPE_SIZE = 10
rope = (0...ROPE_SIZE).map { {r: 0, c: 0} }
tail_visits = Set.new

def board(rope)
  (-20..20).each do |r|
    print r.to_s.rjust(5, " ") + "   "
    (-20..20).each do |c|
      index = rope.index { |cell| cell[:r] == r && cell[:c] == c }
      print index || "."
    end
    puts
  end
  puts
  puts
  puts
end

# This mutates the rope which
# causes us to need to dup the
# entry before adding to the set.
# could we generate a new rope
# each time?
steps.each do |(direction, size)|
  size.to_i.times do
    rope[0] = case direction
    when "D" then {r: rope[0][:r] + 1, c: rope[0][:c] + 0}
    when "U" then {r: rope[0][:r] - 1, c: rope[0][:c] + 0}
    when "L" then {r: rope[0][:r] + 0, c: rope[0][:c] - 1}
    when "R" then {r: rope[0][:r] + 0, c: rope[0][:c] + 1}
    end

    (0...rope.length).each_cons(2) do |a, b|
      delta_r, delta_c = DELTAS.fetch([rope[a][:r] - rope[b][:r], rope[a][:c] - rope[b][:c]], [0, 0])

      rope[b][:r] += delta_r
      rope[b][:c] += delta_c
    end

    tail_visits << rope.last.dup
  end
end

# Print the position where the tail visited
#
# (-40..40).each do |r|
#   (-40..40).each do |c|
#     print tail_visits.include?({r: r, c: c}) ? "#" : "."
#   end
#   puts
# end
# puts
# puts
# puts

p tail_visits.size
