p STDIN
  .readlines(chomp: true)
  .sum { |line|
     line.
       # Parse into the game number and the rest of the line
       scan(/Game (\d+): (.*)/).
       flatten.

       # This one monster line is broken up into steps below.
       # See part 2 for that alternative.
       yield_self { |game, rest|
         [game.to_i, rest.split(";").map { |game| {"red" => 0, "green" => 0, "blue" => 0}.merge(game.scan(/(\d+) (green|blue|red)/).to_h { |count, color| [color, count.to_i]}) }]
       }.

       #  # Split each game into its own component
       #  # [1, ["3 blue, 4 red", " 1 red, 2 green, 6 blue", " 2 green"]]
       #  yield_self { |game, rest|
       #    [game.to_i, rest.split(";")]
       #  }.

       #  # Split each game into a pair of a count and color
       #  # [1, [[["3", "blue"], ["4", "red"]], [["1", "red"], ["2", "green"], ["6", "blue"]], [["2", "green"]]]]
       #  yield_self { |game, games|
       #    [game, games.map { |scores| scores.scan(/(\d+) (green|blue|red)/) }]
       #  }.

       #  # Swap the order of the count and color and make the count an integer
       #  # [1, [[["blue", 3], ["red", 4]], [["red", 1], ["green", 2], ["blue", 6]], [["green", 2]]]]
       #  yield_self { |game, games|
       #    [game, games.map { |scores| scores.map { |count, color| [color, count.to_i] } }]
       #  }.

       #  # Transform each count and color into a hash with the color as a key
       #  # [1, [{"blue"=>3, "red"=>4}, {"red"=>1, "green"=>2, "blue"=>6}, {"green"=>2}]]
       #  yield_self { |game, games|
       #    [game, games.map(&:to_h)]
       #  }.

       #  # Add in keys of `0` for each color that might be missing
       #  # [1, [{"red"=>4, "green"=>0, "blue"=>3}, {"red"=>1, "green"=>2, "blue"=>6}, {"red"=>0, "green"=>2, "blue"=>0}]]
       #  yield_self { |game, games|
       #    [game, games.map { |scores| {"red" => 0, "green" => 0, "blue" => 0}.merge(scores) }]
       #  }.

        # Done parsing here

       yield_self { |game, games|
          games.all? { |scores| scores["red"] <= 12 && scores["green"] <= 13 && scores["blue"] <= 14 } ? game : 0
       }  
  }