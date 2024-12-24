diskmap = STDIN.gets.chomp
blocks = []
file_id = 0
free_space = false
diskmap.each_char do |c|
  if free_space
    blocks += ['.'] * c.to_i
  else
    blocks += [file_id] * c.to_i
    file_id += 1
  end
  free_space = !free_space
end

puts "#{blocks.length} blocks"

i = 0
blocks.pop while blocks.last == '.'
end_pos = blocks.length - 1
while true do
  new_place = blocks.index '.'
  break unless new_place
  break unless new_place < end_pos
  blocks[new_place] = blocks.pop
  end_pos -= 1
  i += 1
  print "\33[2K\r", blocks.count('.') if i % 100 == 0
  # puts blocks.map(&:to_s).join
end

checksum = 0
blocks.each_with_index do |file_id, position|
  checksum += file_id * position
end
puts
puts checksum