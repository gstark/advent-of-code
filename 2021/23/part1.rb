require 'awesome_print'

# amphipods = [
#   { pod: 'A', location: 'ROOM2', destination: 'ROOM1', moved: false },
#   { pod: 'A', location: 'ROOM3', destination: 'ROOM1', moved: false },
#   { pod: 'B', location: 'ROOM3', destination: 'ROOM2', moved: false },
#   { pod: 'B', location: 'ROOM4', destination: 'ROOM2', moved: false },
#   { pod: 'C', location: 'ROOM1', destination: 'ROOM3', moved: false },
#   { pod: 'C', location: 'ROOM2', destination: 'ROOM3', moved: false },
#   { pod: 'D', location: 'ROOM1', destination: 'ROOM4', moved: false },
#   { pod: 'D', location: 'ROOM4', destination: 'ROOM4', moved: false },
# ]

amphipods = [
  { pod: 'A', location: 2, destination: 2, moved: false, energy: 0, cost: 1, moves: "" },
  { pod: 'A', location: 8, destination: 2, moved: false, energy: 0, cost: 1, moves: "" },
  { pod: 'B', location: 2, destination: 4, moved: false, energy: 0, cost: 10, moves: "" },
  { pod: 'B', location: 6, destination: 4, moved: false, energy: 0, cost: 10, moves: "" },
  { pod: 'C', location: 4, destination: 6, moved: false, energy: 0, cost: 100, moves: "" },
  { pod: 'C', location: 6, destination: 6, moved: false, energy: 0, cost: 100, moves: "" },
  { pod: 'D', location: 2, destination: 8, moved: false, energy: 0, cost: 1000, moves: "" },
  { pod: 'D', location: 8, destination: 8, moved: false, energy: 0, cost: 1000, moves: "" },
]

def make_move(amphipods, index)
  count = amphipods.count { |pod| pod[:location] == pod[:destination] }
  if count == 8
    p amphipods.map { |pod| pod[:energy] }
    p amphipods.map { |pod| pod[:moves] }
    p amphipods.sum { |pod| pod[:energy] }
  end

  # puts "\n\n"
  # puts amphipods.map { |pod| "#{pod[:pod]}-#{pod[:location]}" }.join(" ")
  new_amphipods = amphipods.map { |pod| pod.dup }

  pod = new_amphipods[index]

  destinations = [0, 1, 3, 5, 7, 9, 10] - new_amphipods.map { |pod| pod[:location] }
  [2,4,6,8].each do |room|
    destinations << room if pod[:destination] == room # && new_amphipods.select { |row| row[:location] == room }.all? { |row| row[:pod] == pod[:pod] }
  end

  destinations = [] if pod[:destination] == pod[:location] || pod[:moved]

  destinations.each do |destination|
    # puts "Trying to move #{pod[:pod]} currently in #{pod[:location]} to #{destination}"

    source = pod[:location]
    pod[:moves] = pod[:moves] + destination.to_s
    pod[:location] = destination
    pod[:moved] = true
    pod[:energy] += (source - pod[:location]).abs * pod[:cost]

    amphipods.each.with_index do |pod, index|
      next if pod[:location] == pod[:destination] || pod[:moved]
      make_move(new_amphipods, index)
    end
  end

  nil
end

amphipods.each.with_index do |pod, index|
  next if pod[:location] == pod[:destination] || pod[:moved]
  make_move(amphipods, index)
end