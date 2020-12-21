require "amazing_print"
require "set"

def tile_data(tile_lines)
  {
    number: tile_lines[0].gsub(/[^0-9]/, "").to_i,
    orientation: "original",
    top: tile_lines[1],
    bottom: tile_lines.last,
    left: tile_lines[1..].map { |line| line[0] }.join,
    right: tile_lines[1..].map { |line| line[-1] }.join,
  }
end

$tiles = STDIN.readlines(chomp: true).reject(&:empty?).each_slice(11).map { |tile_lines| tile_data(tile_lines) }
$size = Math.sqrt($tiles.size).to_i

$positions = ((0...$size).to_a * 2).combination(2).to_a.uniq.sort

[*$tiles].each do |tile|
  horizontal_flip = {
    bottom: tile[:top], top: tile[:bottom], left: tile[:left].reverse, right: tile[:right].reverse, orientation: "horizontal",
  }

  vertical_flip = {
    top: tile[:top].reverse, bottom: tile[:bottom].reverse, left: tile[:right], right: tile[:left], orientation: "vertical",
  }

  both_flip = {
    orientation: "both",
    top: tile[:right].reverse,
    bottom: tile[:left].reverse,
    left: tile[:bottom].reverse,
    right: tile[:top].reverse,
  }

  both_flip_2 = {
    orientation: "both2",
    top: tile[:left],
    bottom: tile[:right],
    left: tile[:top],
    right: tile[:bottom],
  }

  rotate_90 = {
    orientation: "rotate 90",
    top: tile[:left].reverse,
    bottom: tile[:right].reverse,
    left: tile[:bottom],
    right: tile[:top],
  }

  rotate_180 = {
    orientation: "rotate 180",
    top: tile[:bottom].reverse,
    bottom: tile[:top].reverse,
    left: tile[:right].reverse,
    right: tile[:left].reverse,
  }

  rotate_270 = {
    orientation: "rotate 270",
    top: tile[:right],
    bottom: tile[:left],
    left: tile[:top].reverse,
    right: tile[:bottom].reverse,
  }

  $tiles << { **tile, **horizontal_flip }
  $tiles << { **tile, **vertical_flip }
  $tiles << { **tile, **both_flip }
  $tiles << { **tile, **both_flip_2 }
  $tiles << { **tile, **rotate_90 }
  $tiles << { **tile, **rotate_180 }
  $tiles << { **tile, **rotate_270 }
end

def try_tiles(index, grid, used_tile_numbers)
  if index >= $size ** 2
    p grid[[0, 0]][:number] * grid[[0, $size - 1]][:number] * grid[[$size - 1, 0]][:number] * grid[[$size - 1, $size - 1]][:number]
    grid.each do |position, details|
      p [position, details]
    end
    exit
  end

  col, row = $positions[index]
  possibilities = $tiles.reject { |tile| used_tile_numbers.include?(tile[:number]) }

  possibilities.each do |possible|
    top_pair = grid[[row - 1, col]]
    left_pair = grid[[row, col - 1]]

    match = true

    if left_pair && top_pair
      match = left_pair[:right] == possible[:left] && top_pair[:bottom] == possible[:top]
    end

    if !left_pair && top_pair
      match = top_pair[:bottom] == possible[:top]
    end

    if !top_pair && left_pair
      match = left_pair[:right] == possible[:left]
    end

    if match
      try_tiles(index + 1, { **grid, [row, col] => possible }, Set.new([*used_tile_numbers, possible[:number]]))
    end
  end
end

try_tiles(0, {}, Set.new)
