# This solution is a rework of the solution
# by: https://github.com/jonathanpaulson
#
# It is very creative and very simple. The
# idea is that we are using recursion but on
# three things at once, the current dot, the
# current block index, and finally the length
# of the # current block itself. If we reach
# the end of the dots and we've found all the
# blocks then we have a solution.
#
# A cache with the dots_index, blocks_index, and
# length of the current block is used for optimizing
# the recursion.
#
# One optimization I put in was to simplify the logic
# by always appending a single "." to the end. This
# avoids logic for the case where a block ends DIRECTLY
# at the end of the "dots" string. It removes a conditional
# and makes the code easier to read.
#
# There were also a few "if" conditions in jonathan's code
# that weren't needed and perhaps were left over from the
# initial code.
#
# The idea is not my own... alas

CACHE = {}

def solve(dots, blocks, dots_index, blocks_index, current_block_length)
  CACHE[[dots_index, blocks_index, current_block_length]] ||= begin
    current_dot = dots[dots_index]

    # If we've reached the end of the line (no current dot) and we've
    # found all the blocks return 1, otherwise 0
    if current_dot.nil?
      return (blocks_index == blocks.length) ? 1 : 0
    end

    ans = 0

    # We are at a . or a ? (which could be a . if we wanted it to be)
    if current_dot == "." || current_dot == "?"
      if current_block_length == 0
        # If we are not building a block
        #
        # add up the number of solutions if we looked at the
        # next dot index to start the current block
        #
        # This handles the case where we consider the current ? to be a "."
        ans += solve(dots, blocks, dots_index + 1, blocks_index, 0)
      end

      if current_block_length == blocks[blocks_index]
        # We are building a block and we found a block that is long enough
        #
        # add up the number of solutions if we looked at the
        # next dot index to start the *NEXT* block by incrementing
        # the blocks index and resetting the current block length
        #
        # This is also considering the current ? to be a "." but where
        # doing so, ends a current block.
        ans += solve(dots, blocks, dots_index + 1, blocks_index + 1, 0)
      end
    end

    # If we are at "#" or a "?"
    if current_dot == "#" || current_dot == "?"
      # In either of these cases we can consider this part of the current block
      # so we add the number of solutions if we looked at the
      # next dot index as part of the current block, but incrementing the current block length
      #
      # This handles the case where we consider the current ? to be a #
      ans += solve(dots, blocks, dots_index + 1, blocks_index, current_block_length + 1)
    end

    ans
  end
end

answer = ARGF
  .readlines(chomp: true)
  .sum do |line, i|
    lava, needed_counts = line.split(" ")
    needed_counts = needed_counts.split(",").map(&:to_i)

    lava = ([lava]*5).join("?")
    needed_counts = needed_counts * 5

    # Clear the cache from previous runs
    CACHE.clear

    # Put a "." on the end so we don't have to worry about dangling blocks
    solve(lava + ".", needed_counts, 0, 0, 0)
  end

p answer
