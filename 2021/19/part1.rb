require 'awesome_print'
require 'set'

data = { }

section = nil

$stdin.readlines.each do |line|
  case line
  when /--- scanner (\d+) ---/
  section = $1.to_i
  data[section] = []
  when /(-?\d+),(-?\d+),(-?\d+)/
  data[section] << [$1.to_i, $2.to_i, $3.to_i]
  end 
end

sections = data.keys

def add(point0, point1)
  [
    point0[0] + point1[0],
    point0[1] + point1[1],
    point0[2] + point1[2],
  ]
end

def subtract(point0, point1)
  [
    point0[0] - point1[0],
    point0[1] - point1[1],
    point0[2] - point1[2],
  ]
end

ROTATIONS = [
   proc { |(x,y,z)| [x,y,z] },
   proc { |(x,y,z)| [x,y,-z] },
   proc { |(x,y,z)| [x,-y,z] },
   proc { |(x,y,z)| [x,-y,-z] },
   proc { |(x,y,z)| [-x,y,z] },
   proc { |(x,y,z)| [-x,y,-z] },
   proc { |(x,y,z)| [-x,-y,z] },
   proc { |(x,y,z)| [-x,-y,-z] },

   proc { |(x,y,z)| [x,z,y] },
   proc { |(x,y,z)| [x,z,-y] },
   proc { |(x,y,z)| [x,-z,y] },
   proc { |(x,y,z)| [x,-z,-y] },
   proc { |(x,y,z)| [-x,z,y] },
   proc { |(x,y,z)| [-x,z,-y] },
   proc { |(x,y,z)| [-x,-z,y] },
   proc { |(x,y,z)| [-x,-z,-y] },

   proc { |(x,y,z)| [y,x,z] },
   proc { |(x,y,z)| [y,x,-z] },
   proc { |(x,y,z)| [y,-x,z] },
   proc { |(x,y,z)| [y,-x,-z] },
   proc { |(x,y,z)| [-y,x,z] },
   proc { |(x,y,z)| [-y,x,-z] },
   proc { |(x,y,z)| [-y,-x,z] },
   proc { |(x,y,z)| [-y,-x,-z] },

   proc { |(x,y,z)| [y,z,x] },
   proc { |(x,y,z)| [y,z,-x] },
   proc { |(x,y,z)| [y,-z,x] },
   proc { |(x,y,z)| [y,-z,-x] },
   proc { |(x,y,z)| [-y,z,x] },
   proc { |(x,y,z)| [-y,z,-x] },
   proc { |(x,y,z)| [-y,-z,x] },
   proc { |(x,y,z)| [-y,-z,-x] },

   proc { |(x,y,z)| [z,x,y] },
   proc { |(x,y,z)| [z,x,-y] },
   proc { |(x,y,z)| [z,-x,y] },
   proc { |(x,y,z)| [z,-x,-y] },
   proc { |(x,y,z)| [-z,x,y] },
   proc { |(x,y,z)| [-z,x,-y] },
   proc { |(x,y,z)| [-z,-x,y] },
   proc { |(x,y,z)| [-z,-x,-y] },

   proc { |(x,y,z)| [z,y,x] },
   proc { |(x,y,z)| [z,y,-x] },
   proc { |(x,y,z)| [z,-y,x] },
   proc { |(x,y,z)| [z,-y,-x] },
   proc { |(x,y,z)| [-z,y,x] },
   proc { |(x,y,z)| [-z,y,-x] },
   proc { |(x,y,z)| [-z,-y,x] },
   proc { |(x,y,z)| [-z,-y,-x] },
]


scanner_locations = {0 => [0,0,0]}

to_scan = [0]

loop do
  break if to_scan.empty?

  known_locations = to_scan.dup
  unknown_locations = sections - known_locations

  to_scan = []

  puts "Scanning #{known_locations.inspect} - I know about #{scanner_locations.size} scanners"
  known_locations.each do |scanner_a|
    unknown_locations.each do |scanner_b|
      print "."
      data[scanner_a].each.with_index do |pointa, indexa|
        break if scanner_locations[scanner_b]

        ROTATIONS.each.with_index do |rotation, index|
          break if scanner_locations[scanner_b]

          rotated_data_b = data[scanner_b].map { |point| rotation.call(point) }

          rotated_data_b.each.with_index do |pointb, indexb|
            potential_scanner_b_location = subtract(pointa, pointb)
            points_in_scanner_a_rotation = rotated_data_b.map { |point| add(potential_scanner_b_location, point) }

            matches = data[scanner_a] & points_in_scanner_a_rotation

            if matches.size == 12
              data[scanner_b] = points_in_scanner_a_rotation
              scanner_locations[scanner_b] = potential_scanner_b_location
              to_scan << scanner_b
            end
          end
        end
      end
    end
  end

  puts
end

scanners = data.values.flatten(1).uniq
p scanners.size

# Combinatorically find all distances and take the max
p scanner_locations.values.combination(2).map { |a,b| (a[0] - b[0]).abs + (a[1] - b[1]).abs + (a[2] - b[2]).abs }.max