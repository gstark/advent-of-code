require 'awesome_print'

input = $stdin.readlines(chomp: true).first
# input = "A0016C880162017C3686B18A3D4780"
# input = "8A004A801A8002F478" # represents an operator packet (version 4)
#                              # which contains an operator packet (version 1)
#                              # which contains an operator packet (version 5)
#                              # which contains a literal value (version 6);
#                              # this packet has a version sum of 16.
# input = "A0016C880162017C3686B18A3D4780" # => version sum 31

def parse_packet(input)
  input = input.dup

  origin_length = input.length

  version_sum = input.shift(3).join.to_i(2)
  type = input.shift(3).join.to_i(2)

  if type == 4
    number = []

    loop do
      bits = input.shift(5)

      number.concat(bits[1..])

      break if bits[0] == '0'
    end

    number = number.join.to_i(2)
  else
    case input.shift
    when '0'
      sub_packet_bit_length = input.shift(15).join.to_i(2)

      while sub_packet_bit_length > 0
        results = parse_packet(input)

        input.shift(results[:bits_read])
        version_sum += results[:version_sum]
        sub_packet_bit_length -= results[:bits_read]
      end
    when '1'
      sub_packet_count = input.shift(11).join.to_i(2) 

      sub_packet_count.times do
        results = parse_packet(input)

        input.shift(results[:bits_read])
        version_sum += results[:version_sum]
      end
    end
  end

  { number: number, bits_read: origin_length - input.length, version_sum: version_sum }
end

input = input.chars.map { |digit| digit.to_i(16).to_s(2).rjust(4, '0') }.join.chars.freeze
ap parse_packet(input)