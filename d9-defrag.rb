diskmap = STDIN.gets.chomp
# blocks = []
file_id = 0
free_space = false
free_blocks = []
file_blocks = []
offset = 0
diskmap.each_char do |c|
  len = c.to_i
  if free_space
    free_blocks << [offset, len]
  else
    file_blocks << [offset, len, file_id]
    file_id += 1
  end
  offset += len
  free_space = !free_space
end

puts "Blocks: #{free_blocks.length} free, #{file_blocks.length} used."

file_to_move_idx = file_blocks.length - 1
while file_to_move_idx >= 0 do
  file_to_move = file_blocks[file_to_move_idx]
  file_offset, file_len, file_id = file_to_move

  new_place = free_blocks.find do |free_offset, free_len|
    free_len >= file_len
  end

  if new_place
    free_offset, free_len = new_place
    if free_offset < file_offset
      file_to_move[0] = free_offset
      if free_len > file_len
        new_place[0] += file_len
        new_place[1] -= file_len
      else 
        free_blocks.delete new_place
      end        
    end
  end
  file_to_move_idx -= 1
  print "\33[2K\rFile #{file_id} checked." if file_to_move_idx % 100 == 0
end

checksum = 0
file_blocks.each do |offset, len, id|
  checksum += (offset..offset + len - 1).map { |off| off * id }.reduce(:+)
end
puts
puts checksum
