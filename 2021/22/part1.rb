require 'awesome_print'
require 'set'

lines = $stdin
  .readlines
  .map { |line| line.scan(/(on|off) x=(-?\d+)..(-?\d+),y=(-?\d+)..(-?\d+),z=(-?\d+)..(-?\d+)/).flatten }
  .map { |(instruction, xmin, xmax, ymin, ymax, zmin, zmax)| { instruction: instruction, xmin: xmin.to_i, xmax: xmax.to_i, ymin: ymin.to_i, ymax: ymax.to_i, zmin: zmin.to_i, zmax: zmax.to_i }}
  .delete_if { |line| line[:xmin].abs > 50 || line[:xmax].abs > 50 || line[:ymin].abs > 50 || line[:ymax].abs > 50 || line[:zmin].abs > 50 || line[:zmax].abs > 50 }

cubes = Set.new
lines.each do |line|
  case line[:instruction]
  when "off"
    (line[:xmin]..line[:xmax]).each do |x|
      (line[:ymin]..line[:ymax]).each do |y|
        (line[:zmin]..line[:zmax]).each do |z|
          cubes.delete([x,y,z])
        end
      end
    end
  when "on"
    (line[:xmin]..line[:xmax]).each do |x|
      (line[:ymin]..line[:ymax]).each do |y|
        (line[:zmin]..line[:zmax]).each do |z|
          cubes << [x,y,z]
        end
      end
    end
  end
end

p cubes.size