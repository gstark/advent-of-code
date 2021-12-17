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
  # Duplicate the input so we can freely modify it
  input = input.dup

  # Get the original length so we can compute how many total bits we've read
  origin_length = input.length

  # Get the version number and the type
  version_sum = input.shift(3).join.to_i(2)
  type = input.shift(3).join.to_i(2)

  # If this is a `type 4`, a literal number
  if type == 4
    # Create an array of bits
    number = []

    # Loop until we've seen a stop bit
    loop do
      # Get five total bits
      bits = input.shift(5)

      # Append the last four
      number.concat(bits[1..])

      # But stop if the first bit is a zero
      break if bits[0] == '0'
    end

    # Our number is the numerical value of the bits
    number = number.join.to_i(2)
  else
    # This is an operator

    # Create an array of numbers this operator represents
    numbers = []

    # See which kind of operator we have (the next bit)
    case input.shift
    when '0'
      # Take the first fifteen bits as the total number of bits to process
      sub_packet_bit_length = input.shift(15).join.to_i(2)

      # While we haven't processed that many bits
      while sub_packet_bit_length > 0
        # Parse the next packet
        results = parse_packet(input)

        # Append whatever number this tells us
        numbers << results[:number]

        # Take off the number of bits we consumed
        input.shift(results[:bits_read])

        # Increment the version number sum
        version_sum += results[:version_sum]

        # Note that we've read this many bits
        sub_packet_bit_length -= results[:bits_read]
      end
    when '1'
      # The next 11 bits tells us how many packets to read
      sub_packet_count = input.shift(11).join.to_i(2) 

      # Loop that many times
      sub_packet_count.times do
        # Parse the next packet
        results = parse_packet(input)

        # Append whatever number this tells us
        numbers << results[:number]

        # Take off the number of bits we consumed
        input.shift(results[:bits_read])

        # Increment the version number sum
        version_sum += results[:version_sum]
      end
    end

    # Compute a number based on the operator type
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

  # Return back some statistics
  { number: number, bits_read: origin_length - input.length, version_sum: version_sum }
end

input = input.chars.map { |digit| digit.to_i(16).to_s(2).rjust(4, '0') }.join.chars.freeze

ap parse_packet(input)