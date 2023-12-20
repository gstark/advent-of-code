lines = ARGF.readlines(chomp: true)

MachineModule = Data.define(:name, :inputs, :outputs, :memory, :type)

modules = {}

lines.each do |line|
  name, outputs = line.split(" -> ")
  outputs = outputs.split(", ")

  if name == "broadcaster"
    modules[name] = MachineModule.new(name:, inputs: [], outputs:, memory: nil, type: "broadcaster")
  elsif name.start_with?("%")
    name = name[1..]
    modules[name] = MachineModule.new(name:, inputs: [], outputs:, memory: nil, type: "flipflop")
  elsif name.start_with?("&")
    name = name[1..]
    modules[name] = MachineModule.new(name:, inputs: [], outputs:, memory: nil, type: "conjunction")
  end
end

modules.keys.each do |name|
  mod = modules[name]

  outputs = mod.outputs
  outputs.each do |output|
    modules[output] ||= MachineModule.new(name: output, inputs: [], outputs: [], memory: nil, type: "unknown")
    modules[output].inputs << name
  end
end

modules.select { |name, mod| mod.type == "conjunction" }.each do |name, mod|
  modules[name] = mod.with(memory: mod.inputs.to_h { |name| [name, :low] })
end

modules.select { |name, mod| mod.type == "flipflop" }.each do |name, mod|
  modules[name] = mod.with(memory: false)
end

def button_push(name:, from:, pulse:, queue:, modules:, emits:, cycles:, outputs_to_rx:, presses:)
  current = modules[name]

  loop do
    # If we are sending a high pulse to rx
    if name == outputs_to_rx && pulse == :high
      # Track how many presses it took to get to this cycle
      cycles[from] = presses

      # If we've seen them all, compute the least common multiple
      # and quit since we've made it!
      if cycles.all? { |name, count| count > 0 }
        p cycles.values.reduce(&:lcm)
        exit
      end
    end

    case current.type
    when "broadcaster"
      # Broadcaster sends input signal to all the outputs
      current.outputs.each do |output|
        queue << {name: output, from: name, pulse:}
        # puts "Broadcaster: #{current.name} -#{pulse}-> #{output}"
        emits << pulse
      end
    when "flipflop"
      if pulse == :low
        # Flip from low to high
        memory = modules[current.name].memory
        modules[current.name] = modules[current.name].with(memory: !memory)
        pulse_to_send = (memory == false) ? :high : :low

        current.outputs.each do |output|
          queue << {name: output, from: name, pulse: pulse_to_send}
          emits << pulse_to_send
          # puts "FlipFlop: #{current.name} -#{pulse_to_send}-> #{output}"
        end
      end
    when "conjunction"
      # First remember the input
      new_memory = modules[current.name].memory
      new_memory[from] = pulse
      modules[current.name] = modules[current.name].with(memory: new_memory)

      pulse_to_send = (modules[current.name].memory.all? { |name, value| value == :high }) ? :low : :high

      current.outputs.each do |output|
        queue << {name: output, from: name, pulse: pulse_to_send}
        emits << pulse_to_send
        # puts "Conjunction: #{current.name} -#{pulse_to_send}-> #{output}"
      end
    end

    if queue.empty?
      break
    end

    name, from, pulse = queue.shift.values_at(:name, :from, :pulse)
    current = modules[name]
  end
end

#
# For part2 we want to know when we'd get to a single press of rx
# looking at the input there is only one module that outputs to
# rx, in our input that is "kc". That isn't a good candidate for
# some computation of cycle lengths since it is the same cycle
# as rx. But if we look at what feeds *that* input it may have
# more inputs. We can then keep track if we've seen a high pulse
# to that input as well as how many presses it has taken.
#
# When we've seen all the inputs with a high signal we compute
# the least common multiple of those cycle lengths and stop.
#

# There is only one thing that outputs to rx
outputs_to_rx = modules.find { |name, mod| mod.outputs.include?("rx") }.first

# But there are many things that output to what outputs to rx
# and we'll use that to compute a cycle length
#
# Hash of cycle counts for the elements that output to what outputs to rx
cycles = modules
  .select { |name, mod| mod.outputs.include?(outputs_to_rx) }
  .to_h { |name, _| [name, 0] }

# Don't really need this emits any more but we'll
# keep it to be similar to part1
emits = []

# Keep on keeping on
(1..).each do |presses|
  # Keep similar to part1
  emits << :low
  button_push(name: "broadcaster", from: "button", pulse: :low, queue: [], emits:, modules:, cycles:, outputs_to_rx:, presses:)
end
