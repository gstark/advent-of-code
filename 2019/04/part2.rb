require "set"

range = (245182..790572)

p range.
    # Turn each number into a reversed
    # array of digits
    map(&:digits).map(&:reverse).
    # Select only the digits that are in increasing order.
    # Those that are the same sorted and unsorted
    select { |digits| digits.sort == digits }.
    # Select only the digits where there is at least ONE "run"
    # of the same digit. We take the digits and slice them
    # when successive digits change. If any of those slices
    # has EXACTLY two values, we have a valid number
    select { |digits| digits.slice_when { |a, b| a != b }.any? { |run| run.length == 2 } }.
    # Return the size of this result
    size
