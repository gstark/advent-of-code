instructions = ARGF.readlines(chomp: true)

pwd = ""
tree = {}
instructions.each do |instruction|
  case instruction
  when /^\$ cd \.\./
    pwd = pwd.split("/")[0..-2].join("/")
  when /^\$ cd (.*)/
    pwd = File.join(pwd, $1)
    tree[pwd] ||= {sum: 0}
  when /(\d+) (.*)/
    tree[pwd][$2] = $1.to_i
    tree[pwd][:sum] += $1.to_i
  end
end

p tree
  .to_h { |dir, entries| [dir, tree.select { |tree_dir, _| tree_dir.start_with?(dir) }.sum { |_, tree_entries| tree_entries[:sum] }] }
  .select { |dir, size| size < 100000 }
  .sum { |dir, size| size }
