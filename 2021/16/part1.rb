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

  bits_read = 0
  number = 0

  version = input.shift(3).join.to_i(2)
  bits_read += 3
  type = input.shift(3).join.to_i(2)
  bits_read += 3

  version_sum = version

  case type
  when 4
    number = []

    loop do
      bits_read += 5
      bits = input.shift(5)

      number.concat(input[1..])

      break if bits[0] == '0'
    end

    number = number.join.to_i(2)
  else
    bits_read += 1

    case input.shift
    when '0'
      bits_read += 15
      sub_packet_bit_length = input.shift(15).join.to_i(2)

      while sub_packet_bit_length > 0
        results = parse_packet(input)

        version_sum += results[:version_sum]

        sub_packet_bit_length -= results[:bits_read]

        bits_read += results[:bits_read]

        input = results[:input]
      end
    when '1'
      bits_read += 11
      sub_packet_count = input.shift(11).join.to_i(2) 

      sub_packet_count.times do
        results = parse_packet(input)

        version_sum += results[:version_sum]

        bits_read += results[:bits_read]

        input = results[:input]
      end
    end
  end

  { input: input, version: version, type: type, number: number, bits_read: bits_read, version_sum: version_sum }
end

# input = '110100101111111000101000'
#input = '00111000000000000110111101000101001010010001001000000000' # Operator with 10 and 20 numbers
# input = '1101000101001010010001001000000000' # => 10
# input = '01010010001001000000000' # => 20

# input = '11101110000000001101010000001100100000100011000001100000' # operator with 1, 2, and 3 numbers

input = input.chars.map { |digit| digit.to_i(16).to_s(2).rjust(4, '0') }.join.chars
ap parse_packet(input)