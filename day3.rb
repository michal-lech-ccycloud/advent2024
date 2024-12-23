grab_muls = /(mul\(\d{1,3},\d{1,3}\))|(do\(\))|(don't\(\))/

sum = 0
enabled = true
while memory = STDIN.gets
  memory.to_enum(:scan, grab_muls).each do |cmd|
    puts cmd.inspect
    cmd = cmd.compact.first
    next enabled = true if cmd == "do()"
    next enabled = false if cmd == "don't()"
    i, j = cmd.scan(/\d+/).map(&:to_i)
    sum += i * j if enabled
    print cmd, "\t = ", i * j, "\t", sum, "\n"
  end
end
puts sum
