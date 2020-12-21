require "amazing_print"
require "set"

def tile_data(tile_lines)
  {
    number: tile_lines[0].gsub(/[^0-9]/, "").to_i,
    lines: tile_lines[1..].map(&:chars),
    orientation: "original",
  }
end

$tiles = STDIN.readlines(chomp: true).reject(&:empty?).each_slice(11).map { |tile_lines| tile_data(tile_lines) }
$size = Math.sqrt($tiles.size).to_i

part_1_solution = [
  [[0, 0], { :number => 3931, :orientation => "original", :top => ".##......#", :bottom => ".#..#.#...", :left => "...#..#.#.", :right => "##...##..." }],
  [[1, 0], { :number => 3617, :orientation => "vertical", :top => ".#..#.#...", :bottom => "#..####.##", :left => ".#########", :right => ".#.##.#..#" }],
  [[2, 0], { :number => 2999, :orientation => "both", :top => "#..####.##", :bottom => "..#.#..#.#", :left => "####....#.", :right => "##.##.#..#" }],
  [[3, 0], { :number => 3929, :orientation => "both2", :top => "..#.#..#.#", :bottom => "##.....##.", :left => ".#...#####", :right => "##..##...." }],
  [[4, 0], { :number => 1549, :orientation => "both2", :top => "##.....##.", :bottom => "#.#..##..#", :left => "#.##.#...#", :right => "..#..##..#" }],
  [[5, 0], { :number => 3889, :orientation => "horizontal", :top => "#.#..##..#", :bottom => ".#.#.##.#.", :left => "###.#..#..", :right => "#.##.#.##." }],
  [[6, 0], { :number => 2803, :orientation => "original", :top => ".#.#.##.#.", :bottom => ".......#..", :left => ".#..##.#..", :right => ".######..." }],
  [[7, 0], { :number => 3541, :orientation => "both2", :top => ".......#..", :bottom => "#.#...#.##", :left => "..##.#####", :right => "..#..#...#" }],
  [[8, 0], { :number => 2833, :orientation => "horizontal", :top => "#.#...#.##", :bottom => ".##.#.#..#", :left => "###.####..", :right => "##..######" }],
  [[9, 0], { :number => 3067, :orientation => "both", :top => ".##.#.#..#", :bottom => ".#.#######", :left => "..#..#.#..", :right => "#.#..#####" }],
  [[10, 0], { :number => 2039, :orientation => "original", :top => ".#.#######", :bottom => ".#..#..##.", :left => "...###.#..", :right => "#.####..#." }],
  [[11, 0], { :number => 2411, :orientation => "both2", :top => ".#..#..##.", :bottom => ".###.#.###", :left => "..#.#..##.", :right => "....##...#" }],
  [[0, 1], { :number => 1433, :orientation => "original", :top => "##..#..##.", :bottom => "..#.#...#.", :left => "##...##...", :right => ".....##.#." }],
  [[1, 1], { :number => 1447, :orientation => "rotate 90", :top => "..#.#...#.", :bottom => "#..##..##.", :left => ".#.##.#..#", :right => ".#...####." }],
  [[2, 1], { :number => 1621, :orientation => "both", :top => "#..##..##.", :bottom => "#.###.#...", :left => "##.##.#..#", :right => "....#.#.#." }],
  [[3, 1], { :number => 2663, :orientation => "both", :top => "#.###.#...", :bottom => ".#.#####..", :left => "##..##....", :right => ".##.#.#.#." }],
  [[4, 1], { :number => 1051, :orientation => "rotate 180", :top => ".#.#####..", :bottom => "#..#.#.###", :left => "..#..##..#", :right => ".#.#.#####" }],
  [[5, 1], { :number => 2543, :orientation => "both2", :top => "#..#.#.###", :bottom => "..##.#..#.", :left => "#.##.#.##.", :right => "#..####.#." }],
  [[6, 1], { :number => 2503, :orientation => "both", :top => "..##.#..#.", :bottom => "....#..#..", :left => ".######...", :right => "...#..###." }],
  [[7, 1], { :number => 2903, :orientation => "horizontal", :top => "....#..#..", :bottom => "#.#.###.##", :left => "..#..#...#", :right => "..#.#....#" }],
  [[8, 1], { :number => 2719, :orientation => "vertical", :top => "#.#.###.##", :bottom => "#...#####.", :left => "##..######", :right => "#.#.#..##." }],
  [[9, 1], { :number => 1423, :orientation => "rotate 90", :top => "#...#####.", :bottom => "####..#..#", :left => "#.#..#####", :right => ".....###.#" }],
  [[10, 1], { :number => 1117, :orientation => "original", :top => "####..#..#", :bottom => "....#..#.#", :left => "#.####..#.", :right => "##.##.####" }],
  [[11, 1], { :number => 2687, :orientation => "vertical", :top => "....#..#.#", :bottom => "##.#....##", :left => "....##...#", :right => "###..#..##" }],
  [[0, 2], { :number => 1949, :orientation => "horizontal", :top => "..##....##", :bottom => "....##.#.#", :left => ".....##.#.", :right => "#.###....#" }],
  [[1, 2], { :number => 2063, :orientation => "both", :top => "....##.#.#", :bottom => "...##..#..", :left => ".#...####.", :right => "#.##...##." }],
  [[2, 2], { :number => 1427, :orientation => "both", :top => "...##..#..", :bottom => ".....#.#.#", :left => "....#.#.#.", :right => ".#..#.#..#" }],
  [[3, 2], { :number => 3049, :orientation => "both", :top => ".....#.#.#", :bottom => "...#..##..", :left => ".##.#.#.#.", :right => "#.#.#..#.." }],
  [[4, 2], { :number => 1409, :orientation => "rotate 90", :top => "...#..##..", :bottom => "##......#.", :left => ".#.#.#####", :right => ".##.####.." }],
  [[5, 2], { :number => 1481, :orientation => "both", :top => "##......#.", :bottom => "..##..#.##", :left => "#..####.#.", :right => "..##..##.#" }],
  [[6, 2], { :number => 2963, :orientation => "horizontal", :top => "..##..#.##", :bottom => "..##.##.#.", :left => "...#..###.", :right => "###...#.#." }],
  [[7, 2], { :number => 3023, :orientation => "rotate 180", :top => "..##.##.#.", :bottom => "####.####.", :left => "..#.#....#", :right => ".##..##.#." }],
  [[8, 2], { :number => 1637, :orientation => "both", :top => "####.####.", :bottom => "..#.....##", :left => "#.#.#..##.", :right => ".#...#.###" }],
  [[9, 2], { :number => 3671, :orientation => "original", :top => "..#.....##", :bottom => "###.######", :left => ".....###.#", :right => "#......#.#" }],
  [[10, 2], { :number => 2579, :orientation => "original", :top => "###.######", :bottom => "#..##.####", :left => "##.##.####", :right => "####.#####" }],
  [[11, 2], { :number => 1093, :orientation => "horizontal", :top => "#..##.####", :bottom => "#..#######", :left => "###..#..##", :right => "###.###.##" }],
  [[0, 3], { :number => 2221, :orientation => "horizontal", :top => "##.#.#.##.", :bottom => "#.####..##", :left => "#.###....#", :right => "..#....#.#" }],
  [[1, 3], { :number => 1823, :orientation => "both2", :top => "#.####..##", :bottom => "....##.#..", :left => "#.##...##.", :right => "#..#..##.." }],
  [[2, 3], { :number => 3691, :orientation => "rotate 90", :top => "....##.#..", :bottom => "##.###..#.", :left => ".#..#.#..#", :right => ".######.#." }],
  [[3, 3], { :number => 2957, :orientation => "original", :top => "##.###..#.", :bottom => "..###.##..", :left => "#.#.#..#..", :right => ".#.##.###." }],
  [[4, 3], { :number => 3209, :orientation => "both2", :top => "..###.##..", :bottom => ".#...#...#", :left => ".##.####..", :right => "....######" }],
  [[5, 3], { :number => 1777, :orientation => "both", :top => ".#...#...#", :bottom => "###.##..##", :left => "..##..##.#", :right => "####.....#" }],
  [[6, 3], { :number => 1571, :orientation => "both", :top => "###.##..##", :bottom => "..#...#..#", :left => "###...#.#.", :right => "#.#####..#" }],
  [[7, 3], { :number => 2699, :orientation => "rotate 180", :top => "..#...#..#", :bottom => ".###.#.#..", :left => ".##..##.#.", :right => "####..##.." }],
  [[8, 3], { :number => 2521, :orientation => "both", :top => ".###.#.#..", :bottom => "####...###", :left => ".#...#.###", :right => "..###.#..#" }],
  [[9, 3], { :number => 2213, :orientation => "vertical", :top => "####...###", :bottom => "####.#..##", :left => "#......#.#", :right => "#...#....#" }],
  [[10, 3], { :number => 1063, :orientation => "both2", :top => "####.#..##", :bottom => "##.......#", :left => "####.#####", :right => "##.##.#.##" }],
  [[11, 3], { :number => 3947, :orientation => "both", :top => "##.......#", :bottom => "###.#..#.#", :left => "###.###.##", :right => "#..#.#...#" }],
  [[0, 4], { :number => 2081, :orientation => "original", :top => "..#...#...", :bottom => "#..##.###.", :left => "..#....#.#", :right => "...##...#." }],
  [[1, 4], { :number => 3943, :orientation => "horizontal", :top => "#..##.###.", :bottom => "..#.#.##.#", :left => "#..#..##..", :right => "...#..####" }],
  [[2, 4], { :number => 2371, :orientation => "rotate 90", :top => "..#.#.##.#", :bottom => ".####..#.#", :left => ".######.#.", :right => "##.....###" }],
  [[3, 4], { :number => 1213, :orientation => "rotate 90", :top => ".####..#.#", :bottom => "....##.##.", :left => ".#.##.###.", :right => "#..#......" }],
  [[4, 4], { :number => 2341, :orientation => "both", :top => "....##.##.", :bottom => "###.#.#.#.", :left => "....######", :right => ".#.#.####." }],
  [[5, 4], { :number => 1031, :orientation => "original", :top => "###.#.#.#.", :bottom => "##...#.##.", :left => "####.....#", :right => "..##.#.##." }],
  [[6, 4], { :number => 1039, :orientation => "original", :top => "##...#.##.", :bottom => "#.#.#.####", :left => "#.#####..#", :right => ".#####.#.#" }],
  [[7, 4], { :number => 2659, :orientation => "both2", :top => "#.#.#.####", :bottom => "...###.###", :left => "####..##..", :right => "#...#..###" }],
  [[8, 4], { :number => 1487, :orientation => "original", :top => "...###.###", :bottom => "#.####.#..", :left => "..###.#..#", :right => "#.#...#..." }],
  [[9, 4], { :number => 3301, :orientation => "vertical", :top => "#.####.#..", :bottom => "###...###.", :left => "#...#....#", :right => "..#...##.." }],
  [[10, 4], { :number => 1907, :orientation => "horizontal", :top => "###...###.", :bottom => "###.#....#", :left => "##.##.#.##", :right => ".##..##.##" }],
  [[11, 4], { :number => 3923, :orientation => "rotate 90", :top => "###.#....#", :bottom => "####.#..#.", :left => "#..#.#...#", :right => "##...#...." }],
  [[0, 5], { :number => 3413, :orientation => "horizontal", :top => "....#.####", :bottom => "...#.####.", :left => "...##...#.", :right => "#....#.##." }],
  [[1, 5], { :number => 3371, :orientation => "rotate 90", :top => "...#.####.", :bottom => "#.####....", :left => "...#..####", :right => ".#....###." }],
  [[2, 5], { :number => 3181, :orientation => "rotate 90", :top => "#.####....", :bottom => "#.#..#..##", :left => "##.....###", :right => "...#..#..#" }],
  [[3, 5], { :number => 2917, :orientation => "original", :top => "#.#..#..##", :bottom => ".#.#.#.#.#", :left => "#..#......", :right => "#..##.#.##" }],
  [[4, 5], { :number => 1471, :orientation => "original", :top => ".#.#.#.#.#", :bottom => ".#####.##.", :left => ".#.#.####.", :right => "##..#.#.#." }],
  [[5, 5], { :number => 3019, :orientation => "vertical", :top => ".#####.##.", :bottom => "...#...##.", :left => "..##.#.##.", :right => "....###..." }],
  [[6, 5], { :number => 1697, :orientation => "horizontal", :top => "...#...##.", :bottom => "##.###.#..", :left => ".#####.#.#", :right => "..##..###." }],
  [[7, 5], { :number => 2777, :orientation => "rotate 180", :top => "##.###.#..", :bottom => "#..#.###.#", :left => "#...#..###", :right => "..#..#####" }],
  [[8, 5], { :number => 3877, :orientation => "horizontal", :top => "#..#.###.#", :bottom => "..######.#", :left => "#.#...#...", :right => "#.#####.##" }],
  [[9, 5], { :number => 3917, :orientation => "vertical", :top => "..######.#", :bottom => "...#...###", :left => "..#...##..", :right => "#.#.###..#" }],
  [[10, 5], { :number => 1987, :orientation => "rotate 180", :top => "...#...###", :bottom => "##.###.##.", :left => ".##..##.##", :right => "#.##...#.." }],
  [[11, 5], { :number => 3221, :orientation => "vertical", :top => "##.###.##.", :bottom => ".##...###.", :left => "##...#....", :right => ".####..#.." }],
  [[0, 6], { :number => 2143, :orientation => "horizontal", :top => "#.##....##", :bottom => ".######..#", :left => "#....#.##.", :right => "#.###.##.#" }],
  [[1, 6], { :number => 1297, :orientation => "rotate 90", :top => ".######..#", :bottom => ".....#.##.", :left => ".#....###.", :right => "#..#.##..." }],
  [[2, 6], { :number => 1367, :orientation => "vertical", :top => ".....#.##.", :bottom => "##....#..#", :left => "...#..#..#", :right => ".##.##.#.#" }],
  [[3, 6], { :number => 3037, :orientation => "both2", :top => "##....#..#", :bottom => "####..###.", :left => "#..##.#.##", :right => "#..###.#.." }],
  [[4, 6], { :number => 2393, :orientation => "both", :top => "####..###.", :bottom => "....#.....", :left => "##..#.#.#.", :right => ".#..###..." }],
  [[5, 6], { :number => 1741, :orientation => "vertical", :top => "....#.....", :bottom => ".#...#....", :left => "....###...", :right => ".#.#.###.." }],
  [[6, 6], { :number => 2887, :orientation => "both2", :top => ".#...#....", :bottom => ".##.#.#...", :left => "..##..###.", :right => ".#..##...." }],
  [[7, 6], { :number => 2069, :orientation => "horizontal", :top => ".##.#.#...", :bottom => "##..#.#.##", :left => "..#..#####", :right => ".#.###..##" }],
  [[8, 6], { :number => 1123, :orientation => "rotate 180", :top => "##..#.#.##", :bottom => "#...###..#", :left => "#.#####.##", :right => "##....####" }],
  [[9, 6], { :number => 3779, :orientation => "horizontal", :top => "#...###..#", :bottom => "##.#......", :left => "#.#.###..#", :right => "####.##.#." }],
  [[10, 6], { :number => 1103, :orientation => "vertical", :top => "##.#......", :bottom => ".#.#####.#", :left => "#.##...#..", :right => ".#...#.#.#" }],
  [[11, 6], { :number => 2677, :orientation => "both", :top => ".#.#####.#", :bottom => "........#.", :left => ".####..#..", :right => "###......." }],
  [[0, 7], { :number => 3307, :orientation => "original", :top => "####..##.#", :bottom => "##.#..#...", :left => "#.###.##.#", :right => "#.#...###." }],
  [[1, 7], { :number => 3469, :orientation => "horizontal", :top => "##.#..#...", :bottom => "..##.#....", :left => "#..#.##...", :right => ".##.###..." }],
  [[2, 7], { :number => 2383, :orientation => "rotate 90", :top => "..##.#....", :bottom => "####..#.#.", :left => ".##.##.#.#", :right => ".####.###." }],
  [[3, 7], { :number => 2969, :orientation => "both2", :top => "####..#.#.", :bottom => "..#.####..", :left => "#..###.#..", :right => ".###......" }],
  [[4, 7], { :number => 2287, :orientation => "original", :top => "..#.####..", :bottom => ".#.#..#.##", :left => ".#..###...", :right => "....#....#" }],
  [[5, 7], { :number => 3121, :orientation => "original", :top => ".#.#..#.##", :bottom => ".##..#.##.", :left => ".#.#.###..", :right => "#...####.." }],
  [[6, 7], { :number => 2753, :orientation => "horizontal", :top => ".##..#.##.", :bottom => "..#.#####.", :left => ".#..##....", :right => ".#..#..#.." }],
  [[7, 7], { :number => 1531, :orientation => "original", :top => "..#.#####.", :bottom => "#....##.##", :left => ".#.###..##", :right => ".#.##.#.##" }],
  [[8, 7], { :number => 1753, :orientation => "rotate 180", :top => "#....##.##", :bottom => "##.##.##.#", :left => "##....####", :right => "#...#.####" }],
  [[9, 7], { :number => 1801, :orientation => "horizontal", :top => "##.##.##.#", :bottom => "..###...##", :left => "####.##.#.", :right => "######.#.#" }],
  [[10, 7], { :number => 2837, :orientation => "both2", :top => "..###...##", :bottom => "#####.....", :left => ".#...#.#.#", :right => "#....###.." }],
  [[11, 7], { :number => 1693, :orientation => "both2", :top => "#####.....", :bottom => ".#.##.#...", :left => "###.......", :right => ".##..###.." }],
  [[0, 8], { :number => 1249, :orientation => "vertical", :top => "#####.#.##", :bottom => ".##...##..", :left => "#.#...###.", :right => "#....#..#." }],
  [[1, 8], { :number => 2029, :orientation => "both", :top => ".##...##..", :bottom => "..##.##..#", :left => ".##.###...", :right => "....###.##" }],
  [[2, 8], { :number => 1021, :orientation => "rotate 90", :top => "..##.##..#", :bottom => "...##.##.#", :left => ".####.###.", :right => "#...######" }],
  [[3, 8], { :number => 2269, :orientation => "rotate 90", :top => "...##.##.#", :bottom => "..#....###", :left => ".###......", :right => "###.#..###" }],
  [[4, 8], { :number => 3697, :orientation => "rotate 180", :top => "..#....###", :bottom => "#..#.#....", :left => "....#....#", :right => "###.##.##." }],
  [[5, 8], { :number => 1613, :orientation => "both2", :top => "#..#.#....", :bottom => ".#.##....#", :left => "#...####..", :right => "..##.##.##" }],
  [[6, 8], { :number => 1901, :orientation => "horizontal", :top => ".#.##....#", :bottom => ".##.......", :left => ".#..#..#..", :right => "##.##....." }],
  [[7, 8], { :number => 1601, :orientation => "vertical", :top => ".##.......", :bottom => "##..###..#", :left => ".#.##.#.##", :right => ".#######.#" }],
  [[8, 8], { :number => 1483, :orientation => "rotate 90", :top => "##..###..#", :bottom => "#####.#...", :left => "#...#.####", :right => "##.##...#." }],
  [[9, 8], { :number => 1783, :orientation => "horizontal", :top => "#####.#...", :bottom => "#.#####...", :left => "######.#.#", :right => ".#..#.###." }],
  [[10, 8], { :number => 2789, :orientation => "both", :top => "#.#####...", :bottom => ".###.##.##", :left => "#....###..", :right => "..#...#.##" }],
  [[11, 8], { :number => 1163, :orientation => "original", :top => ".###.##.##", :bottom => ".#...#..#.", :left => ".##..###..", :right => "#..###.##." }],
  [[0, 9], { :number => 1049, :orientation => "rotate 90", :top => "##....#.#.", :bottom => ".#....#..#", :left => "#....#..#.", :right => "..#.##.#.#" }],
  [[1, 9], { :number => 2309, :orientation => "rotate 180", :top => ".#....#..#", :bottom => "##.#..#..#", :left => "....###.##", :right => "#.#.##.###" }],
  [[2, 9], { :number => 1229, :orientation => "vertical", :top => "##.#..#..#", :bottom => "#.###..##.", :left => "#...######", :right => "#....##..." }],
  [[3, 9], { :number => 2477, :orientation => "both2", :top => "#.###..##.", :bottom => "#.##...#.#", :left => "###.#..###", :right => "..##.....#" }],
  [[4, 9], { :number => 1307, :orientation => "horizontal", :top => "#.##...#.#", :bottom => "...#.....#", :left => "###.##.##.", :right => "##.#..####" }],
  [[5, 9], { :number => 1361, :orientation => "original", :top => "...#.....#", :bottom => "##.#.#.###", :left => "..##.##.##", :right => "#.###...##" }],
  [[6, 9], { :number => 1187, :orientation => "both2", :top => "##.#.#.###", :bottom => ".#.....##.", :left => "##.##.....", :right => "#..#.####." }],
  [[7, 9], { :number => 2129, :orientation => "horizontal", :top => ".#.....##.", :bottom => "######..#.", :left => ".#######.#", :right => ".#..##.##." }],
  [[8, 9], { :number => 1303, :orientation => "vertical", :top => "######..#.", :bottom => ".###.#.#.#", :left => "##.##...#.", :right => "..##.#.###" }],
  [[9, 9], { :number => 3709, :orientation => "both", :top => ".###.#.#.#", :bottom => ".#..##.#.#", :left => ".#..#.###.", :right => "##...#..##" }],
  [[10, 9], { :number => 1559, :orientation => "both2", :top => ".#..##.#.#", :bottom => "#####....#", :left => "..#...#.##", :right => "#..#.....#" }],
  [[11, 9], { :number => 3499, :orientation => "rotate 90", :top => "#####....#", :bottom => ".#..#..###", :left => "#..###.##.", :right => "########.#" }],
  [[0, 10], { :number => 1451, :orientation => "both2", :top => "....#.#...", :bottom => "#....##..#", :left => "..#.##.#.#", :right => ".##...#.##" }],
  [[1, 10], { :number => 1931, :orientation => "both2", :top => "#....##..#", :bottom => "###..##...", :left => "#.#.##.###", :right => "#.......#." }],
  [[2, 10], { :number => 2357, :orientation => "both", :top => "###..##...", :bottom => ".#.#.#.#..", :left => "#....##...", :right => "..#.#....." }],
  [[3, 10], { :number => 1499, :orientation => "horizontal", :top => ".#.#.#.#..", :bottom => "#...####.#", :left => "..##.....#", :right => ".#..##.###" }],
  [[4, 10], { :number => 1321, :orientation => "vertical", :top => "#...####.#", :bottom => "#.#.#.#..#", :left => "##.#..####", :right => "###...#..#" }],
  [[5, 10], { :number => 3391, :orientation => "rotate 180", :top => "#.#.#.#..#", :bottom => "#...##..##", :left => "#.###...##", :right => "#.#.#.#.##" }],
  [[6, 10], { :number => 1913, :orientation => "vertical", :top => "#...##..##", :bottom => ".#.##...#.", :left => "#..#.####.", :right => "#.##.#...." }],
  [[7, 10], { :number => 3491, :orientation => "original", :top => ".#.##...#.", :bottom => ".####.....", :left => ".#..##.##.", :right => "..#.#.#..." }],
  [[8, 10], { :number => 3407, :orientation => "horizontal", :top => ".####.....", :bottom => "##..#.###.", :left => "..##.#.###", :right => "..#####..." }],
  [[9, 10], { :number => 1373, :orientation => "vertical", :top => "##..#.###.", :bottom => "####......", :left => "##...#..##", :right => ".....##..." }],
  [[10, 10], { :number => 3739, :orientation => "rotate 90", :top => "####......", :bottom => "##..#....#", :left => "#..#.....#", :right => ".#...###.#" }],
  [[11, 10], { :number => 1553, :orientation => "both2", :top => "##..#....#", :bottom => "##..#..#..", :left => "########.#", :right => "#.#......." }],
  [[0, 11], { :number => 2113, :orientation => "both", :top => ".#....##.#", :bottom => "##.....#.#", :left => ".##...#.##", :right => "#.###..###" }],
  [[1, 11], { :number => 3191, :orientation => "horizontal", :top => "##.....#.#", :bottom => ".###..#.#.", :left => "#.......#.", :right => "#...#.##.." }],
  [[2, 11], { :number => 3823, :orientation => "horizontal", :top => ".###..#.#.", :bottom => "...####.##", :left => "..#.#.....", :right => ".###.....#" }],
  [[3, 11], { :number => 2381, :orientation => "original", :top => "...####.##", :bottom => "#.#...#.#.", :left => ".#..##.###", :right => "#........." }],
  [[4, 11], { :number => 1543, :orientation => "both2", :top => "#.#...#.#.", :bottom => "####.##...", :left => "###...#..#", :right => "..#..###.." }],
  [[5, 11], { :number => 2879, :orientation => "horizontal", :top => "####.##...", :bottom => "###..#.#..", :left => "#.#.#.#.##", :right => "..####...." }],
  [[6, 11], { :number => 2731, :orientation => "vertical", :top => "###..#.#..", :bottom => "..#......#", :left => "#.##.#....", :right => ".#....#.##" }],
  [[7, 11], { :number => 3767, :orientation => "vertical", :top => "..#......#", :bottom => ".###.#.##.", :left => "..#.#.#...", :right => "#.#.#.##.." }],
  [[8, 11], { :number => 1997, :orientation => "vertical", :top => ".###.#.##.", :bottom => ".#.###.#.#", :left => "..#####...", :right => "...###..##" }],
  [[9, 11], { :number => 2141, :orientation => "rotate 90", :top => ".#.###.#.#", :bottom => ".#..#.#.##", :left => ".....##...", :right => "#.#.#..#.#" }],
  [[10, 11], { :number => 3637, :orientation => "both2", :top => ".#..#.#.##", :bottom => "#.#.##..##", :left => ".#...###.#", :right => "#######.##" }],
  [[11, 11], { :number => 2251, :orientation => "both2", :top => "#.#.##..##", :bottom => ".##....#..", :left => "#.#.......", :right => "##..#.#..." }],
]

_part_1_solution = [
  [[0, 0], { :number => 2971, :orientation => "original", :top => "..#.#....#", :bottom => "...#.#.#.#", :left => ".###..#...", :right => "#...##.#.#" }],
  [[1, 0], { :number => 2729, :orientation => "original", :top => "...#.#.#.#", :bottom => "#.##...##.", :left => ".#....####", :right => "#..#......" }],
  [[2, 0], { :number => 1951, :orientation => "original", :top => "#.##...##.", :bottom => "#...##.#..", :left => "##.#..#..#", :right => ".#####..#." }],
  [[0, 1], { :number => 1489, :orientation => "original", :top => "##.#.#....", :bottom => "###.##.#..", :left => "#...##.#.#", :right => ".....#..#." }],
  [[1, 1], { :number => 1427, :orientation => "original", :top => "###.##.#..", :bottom => "..##.#..#.", :left => "#..#......", :right => "..###.#.#." }],
  [[2, 1], { :number => 2311, :orientation => "original", :top => "..##.#..#.", :bottom => "..###..###", :left => ".#####..#.", :right => "...#.##..#" }],
  [[0, 2], { :number => 1171, :orientation => "rotate 180", :top => "...##.....", :bottom => ".##...####", :left => ".....#..#.", :right => ".##....###" }],
  [[1, 2], { :number => 2473, :orientation => "rotate 90", :top => ".##...####", :bottom => "..#.###...", :left => "..###.#.#.", :right => "#....####." }],
  [[2, 2], { :number => 3079, :orientation => "horizontal", :top => "..#.###...", :bottom => "#.#.#####.", :left => "...#.##..#", :right => "...#....#." }],
]

def rotate(orientation, two_dimension_array)
  case orientation
  when "original"
    return two_dimension_array
  when "horizontal"
    return two_dimension_array.reverse
  when "vertical"
    return two_dimension_array.map(&:reverse)
  when "rotate 90"
    return two_dimension_array.transpose.map(&:reverse)
  when "rotate 180"
    return two_dimension_array.reverse.map(&:reverse)
  when "rotate 270"
    return two_dimension_array.transpose.reverse
  when "both"
    return two_dimension_array.transpose.map(&:reverse).reverse
  when "both2"
    return two_dimension_array.transpose
  else
    raise orientation
  end
end

def display(orientation, grid)
  rotate(orientation, grid).map { |line| line&.join || "" }.join("\n")
end

full_grid = []
part_1_solution.each do |(row, col), details|
  tile = $tiles.find { |tile| tile[:number] == details[:number] }
  lines = rotate(details[:orientation], tile[:lines])

  (0..9).each do |dx|
    (0..9).each do |dy|
      x = col * 10 + dx
      y = row * 10 + dy
      full_grid[y] ||= []
      c = lines[dy][dx]
      c = c.red if dx == 0 || dy == 0 || dx == 9 || dy == 9
      full_grid[y][x] = c
    end
  end
end

puts display("original", full_grid)

# Make a new grid with all the borders deleted
grid = full_grid.map { |line| line.delete("#".red); line.delete(".".red); line }.reject { |line| line.empty? }

pattern = %{
                  # 
#    ##    ##    ###
 #  #  #  #  #  #   
}

pattern = pattern[1..].split("\n").map(&:chars).flat_map.with_index { |row, row_index| row.map.with_index { |col, col_index| [row_index, col_index, col] } }.reject { |row_index, col_index, char| char == " " }

orientations = [
  "original",
  "horizontal",
  "vertical",
  "rotate 90",
  "rotate 180",
  "rotate 270",
  "both",
]

orientations.find do |orientation|
  new_grid = rotate(orientation, grid)

  sum = (0..grid.length).sum do |row_index|
    (0..grid.length).count do |col_index|
      found = pattern.all? { |delta_row, delta_col, _| new_grid[row_index + delta_row] && new_grid[row_index + delta_row][col_index + delta_col] == "#" }
      pattern.each { |delta_row, delta_col, _| new_grid[row_index + delta_row][col_index + delta_col] = "O".red } if found
    end
  end

  if sum > 0
    puts display("original", new_grid)
    p new_grid.flatten.count("#")
  end
end
