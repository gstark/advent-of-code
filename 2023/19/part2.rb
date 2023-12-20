# This is a very clever algorithm.
#
# I did not come up with it myself. However after reading
# a few hints I did implement something _very_ close to what
# this is. The idea of "splitting the ranges" coupled with
# recursion is a good idea, I just couldn't get it to the
# finish line.
#
# Credit to hyper-neutrino for the inspiration
# See code: https://github.com/hyper-neutrino/advent-of-code/blob/main/2023/day19p2.py
# See video: https://www.youtube.com/watch?v=3RwIpUegdU4
#
# The essence of the algorithm is to start with a full range for each x, m, a, s
# then for each transition we look at the sequence of instructions. For each instruction
# we look at the x/m/a/s, operation, and value. We create a new range for that x/m/a/s
# for the case where the operation/value is true, and one where it is false
#
# We recurse on the true range ONLY IF the range isn't 0 length.
#
# If the false range is non-empty, we assign it to the current
# letter since we'll be moving past it to the *next* code condition
# and in order for that condition to be considered the first one
# would have to be false...
#
# It might be interesting to parse the input to not have multiple
# code conditions but to insert pseudo states such that each
# workflow contains only a single condition and a default. This
# would greatly simplify the logic of the recursion.

workflows, _ = ARGF.read.split("\n\n")

workflows = workflows
  .split("\n")
  .map { |line| line.scan(/([a-z]+){(.*)}/).flatten }
  .map { |name, instructions| [name, instructions.split(",").map { |instruction| instruction.include?(":") ? instruction.split(":").yield_self { |code, destination| {code: code.scan(/(\w+)([<>])(\d+)/).flatten, destination:} } : {destination: instruction} }] }
  .map { |name, instructions| [name, instructions.each { |instruction| instruction[:code][-1] = instruction[:code][-1].to_i if instruction[:code] }] }
  .to_h

#
# name: the destination workflow name
# workflows: our workflows
# ranges: the current narrowed ranges for "x", "m", "a", and "s"
#
def compute(name, workflows, ranges)
  # We are at an acceptance so return the value of multiplying
  # all the range sizes
  if name == "A"
    return ranges.values.map(&:size).reduce(:*)
  end

  # Reject, so score zero
  if name == "R"
    return 0
  end

  # Go through each rule for the workflow for this destination
  total = 0
  workflows[name].each do |rule|
    # get the target destination and the
    # instruction code for this workflow
    target, code = rule.values_at(:destination, :code)

    # If there are no codes, just compute the answer
    # for the target without # changing the ranges.
    # This code is _always_ at the end of the list
    # of codes based on how the input is. We could
    # also treat it as that kind of special case.
    # See: "(The last rule in each workflow has no
    # condition and always applies if reached.)"
    if code.nil?
      total += compute(target, workflows, ranges)
    else
      # Get the new target, operation and value from the code
      new_target, operation, value = code

      # Split the range for the target we are going to.
      # We use the operation to create a range where the
      # rule is true, and a range where the rule is false
      case operation
      when "<"
        # When we are comparing less, the true range begins
        # where it already is and ends one less than the value
        true_range = ranges[new_target].begin..value - 1

        # When we are comparing less, the false range
        # starts at the value (e.g. >=) and ends at the
        # existing end of the range.
        false_range = value..ranges[new_target].end
      when ">"
        # When we are comparing more, the true range begins
        # just past the value and ends where it already is
        true_range = value + 1..ranges[new_target].end

        # When we are comparing more, the false range begins
        # where we once did and ends at the value
        false_range = ranges[new_target].begin..value
      end

      # If the true range is valid, then we will
      # recurse and accumulate a total
      if true_range.size > 0
        # This is a ruby trick for hash expansion.
        #
        # If you come from javascript it is like {...object, key: new_value}
        total += compute(target, workflows, {**ranges, new_target => true_range})
      end

      # If there is a false part of the range, we
      # replace the current range such that the new
      # target's range is the false part
      if false_range.size > 0
        # See above for hash expansion and replacement
        ranges = {**ranges, new_target => false_range}
      end
    end
  end

  # Return the accumulated total
  total
end

# Compute starting at "in" with ranges from 1 to 4000
p compute("in", workflows, "xmas".chars.to_h { |char| [char, 1..4000] })
