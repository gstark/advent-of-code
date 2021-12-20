require 'awesome_print'
require 'set'

beacons = { }

section = nil

$stdin.readlines.each do |line|
  case line
  when /--- scanner (\d+) ---/
  section = $1.to_i
  beacons[section] = []
  when /(-?\d+),(-?\d+),(-?\d+)/
  beacons[section] << [$1.to_i, $2.to_i, $3.to_i]
  end 
end

sections = beacons.keys

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

# We know about scanner 0, we'll assume that it is at 0,0,0
freshly_located_scanners = [0]

loop do
  # If we found all the scanners, stop
  break if scanner_locations.keys.size == sections.size

  # Look around at all the unknown scanners
  unknown_scanners = sections - scanner_locations.keys

  # Make a list of the scanners to test next time
  next_scan = []

  puts "Scanning #{freshly_located_scanners.inspect} - I know about #{scanner_locations.size} scanners"

  unknown_scanners.each do |unknown_scanner|
    print "."
    freshly_located_scanners.each do |known_scanner|
      break if scanner_locations[unknown_scanner]

      ROTATIONS.each.with_index do |rotation, index|
        break if scanner_locations[unknown_scanner]
        rotated_beacons = beacons[unknown_scanner].map(&rotation)

        beacons[known_scanner].each.with_index do |known_beacon, indexa|
          break if scanner_locations[unknown_scanner]

          rotated_beacons.each.with_index do |beacon, indexb|
            break if scanner_locations[unknown_scanner]

            beacon_location = subtract(known_beacon, beacon)
            points_in_known_scanner_reference = rotated_beacons.map { |point| add(beacon_location, point) }

            matches = beacons[known_scanner] & points_in_known_scanner_reference

            if matches.size == 12
              beacons[unknown_scanner] = points_in_known_scanner_reference
              scanner_locations[unknown_scanner] = beacon_location
              next_scan << unknown_scanner
            end
          end
        end
      end
    end
  end

  freshly_located_scanners = next_scan
  puts
end

scanners = beacons.values.flatten(1).uniq
p scanners.size

# Combinatorically find all distances and take the max
p scanner_locations.values.combination(2).map { |a,b| (a[0] - b[0]).abs + (a[1] - b[1]).abs + (a[2] - b[2]).abs }.max