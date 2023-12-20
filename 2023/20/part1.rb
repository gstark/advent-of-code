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

def button_push(name:, from:, pulse:, queue:, modules:, emits:)
  current = modules[name]

  loop do
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

emits = []
1000.times do
  emits << :low
  button_push(name: "broadcaster", from: "button", pulse: :low, queue: [], emits:, modules:)
  # puts
  # puts
end
# p emits.tally
p emits.tally.values.reduce(&:*)
