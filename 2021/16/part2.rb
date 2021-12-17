require 'awesome_print'

input = $stdin.readlines(chomp: true).first
# input = "A0016C880162017C3686B18A3D4780"
# input = "8A004A801A8002F478" # represents an operator packet (version 4)
#                              # which contains an operator packet (version 1)
#                              # which contains an operator packet (version 5)
#                              # which contains a literal value (version 6);
#                              # this packet has a version sum of 16.
# input = "A0016C880162017C3686B18A3D4780" # => version sum 31

# input = "C200B40A82" # finds the sum of 1 and 2, resulting in the value 3.
# input = "9C0141080250320F1802104A08" # produces 1, because 1 + 3 = 2 * 2.

def parse_packet(input)
  input = input.dup

  origin_length = input.length
  version = input.shift(3).join.to_i(2)
  type = input.shift(3).join.to_i(2)

  version_sum = version

  case type
  when 4
    number = []

    loop do
      bits = input.shift(5)

      number.concat(bits[1..])

      break if bits[0] == '0'
    end

    number = number.join.to_i(2)
  else
    numbers = []

    case input.shift
    when '0'
      sub_packet_bit_length = input.shift(15).join.to_i(2)

      while sub_packet_bit_length > 0
        results = parse_packet(input)

        numbers << results[:number]
        input = results[:input]
        version_sum += results[:version_sum]
        sub_packet_bit_length -= results[:bits_read]
      end
    when '1'
      sub_packet_count = input.shift(11).join.to_i(2) 

      sub_packet_count.times do
        results = parse_packet(input)

        numbers << results[:number]
        input = results[:input]
        version_sum += results[:version_sum]
      end
    end

    number = case type
             when 0 then numbers.sum
             when 1 then numbers.reduce(:*)
             when 2 then numbers.min
             when 3 then numbers.max
             when 5 then numbers.first > numbers.last ? 1 : 0
             when 6 then numbers.first < numbers.last ? 1 : 0
             when 7 then numbers.first == numbers.last ? 1 : 0
             end
  end

  { input: input, version: version, type: type, number: number, bits_read: origin_length - input.length, version_sum: version_sum }
end

input = input.chars.map { |digit| digit.to_i(16).to_s(2).rjust(4, '0') }.join.chars
ap parse_packet(input)