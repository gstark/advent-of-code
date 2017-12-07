input = 312051

#def ur(n)
#  1 + n.times.map { |i| 2 + i*8 }.sum
#end
#
#def ul(n)
#  1 + n.times.map { |i| 4 + i*8 }.sum
#end
#
#def ll(n)
#  1 + n.times.map { |i| 6 + i*8 }.sum
#end
#
#def lr(n)
#  1 + n.times.map { |i| 8 + i*8 }.sum
#end
#
#def find_horizontal_distance_and_side(input)
#  (0..1000).find do |i|
#    break [i, ur(i)..ul(i)]       if (ur(i)..ul(i)).include?(input)
#    break [i, ul(i)..ll(i)]       if (ul(i)..ll(i)).include?(input)
#    break [i, ll(i)..lr(i)]       if (ll(i)..lr(i)).include?(input)
#    break [i, (lr(i-1)+1)..ur(i)] if ((lr(i-1)+1)..ur(i)).include?(input)
#  end
#end
#

#horizontal_distance, side = find_horizontal_distance_and_side(input)
#
#vertical_distance = (input - (side.max + side.min)/2).abs
#p horizontal_distance + vertical_distance

def mids(horizontal_distance)
  return [1] if horizontal_distance == 0

  first = mids(horizontal_distance - 1).last - 1
  (0..3).map { |i| first + horizontal_distance * 2 * (i + 1) }
end

horizontal_distance, middle = (0..Float::INFINITY).
                                 lazy.
                                 map { |horizontal_distance| [horizontal_distance, mids(horizontal_distance)] }.
                                 find { |horizontal_distance, middles| input.between?(middles.first, middles.last) }

vertical_distance = middle.map { |x| (input-x).abs }.min

p horizontal_distance + vertical_distance
