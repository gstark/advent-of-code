p STDIN
  .readlines(chomp: true)
  .sum { |line|
     line
       .scan(/Game (\d+): (.*)/)
       .flatten
       .yield_self { |game, scores|
          [game.to_i, scores.split(";").flat_map { |scores| scores.split(";").map { |scores| {"red" => 0, "green" => 0, "blue" => 0}.merge(scores.split(",").map { |score| score.split(" ").reverse }.to_h.transform_values(&:to_i)) } }]
       }
       .yield_self { |game, scores|
          scores.all? { |scores| scores["red"] <= 12 && scores["green"] <= 13 && scores["blue"] <= 14 } ? game : 0
       }  
  }