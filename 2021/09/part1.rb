require 'awesome_print'

ap $stdin.read.
          split("\n").
          map(&:chars).
          map.
          with_index { |row, row_index| row.map.with_index { |height, col_index| [[row_index, col_index], height.to_i] } }.
          flatten(1).
          to_h.
          yield_self { |heights|
            heights.select { |(row, col), height|
              [
                heights[[row-1, col+0]],
                heights[[row+1, col+0]],

                heights[[row+0, col-1]],
                heights[[row+0, col+1]],
              ].compact.all? { |neighbor| neighbor > height }
            }
          }.
          values.
          map(&:succ).
          sum