

MOVES = {
  "^" => { step: { y: -1, x:  0 }, turn: ">" },
  ">" => { step: { y:  0, x:  1 }, turn: "v" },
  "v" => { step: { y:  1, x:  0 }, turn: "<" },
  "<" => { step: { y:  0, x: -1 }, turn: "^" }
}

map = []
guard = { }
puts
while next_row = STDIN.gets&.chomp do
  if find_guard_x = next_row =~ /[v><^]/
    guard[:x] = find_guard_x
    guard[:y] = map.length
    guard[:direction] = next_row[find_guard_x]
  end
  map << next_row
  # puts next_row
end

def uniques_or_loop(map, guard_start)
  w = map.first.length
  h = map.length
  guard_x = guard_start[:x]
  guard_y = guard_start[:y]
  direction = guard_start[:direction]
  
  # new_position = true
  unique_steps = 0
  turns = []
  # puts guard_start
  while true
    # puts MOVES
    # puts guard_start
    move = MOVES[direction]
    # puts move
    next_x = guard_x + move[:step][:x]
    next_y = guard_y + move[:step][:y]
    # new_position = map[next_y][next_x] == '.'

    # map[guard_y][guard_x] = direction
    # puts "\033[2J\033[0;0H" + map.join("\n") + "\n#{unique_steps}"   
  
    break if next_x < 0 || next_y < 0
    break unless next_x < w && next_y < h
  
    if "#*".include? map[next_y][next_x]
      return :loop if turns.include? [guard_y, guard_x, direction]
      turns << [guard_y, guard_x, direction]
      next direction = move[:turn] 
    end
  
    unique_steps += 1 if map[next_y][next_x] == '.'
    map[guard_y][guard_x] = 'X'
    guard_x = next_x
    guard_y = next_y
  end
  unique_steps + 1
end

def draw_map(map)
  puts "\033[2J\033[0;0H" + map.join("\n")
end

puts

loops = []
map.each_index do |insert_y|
  map.first.length.times do |insert_x|
    try_map = map.join("\n").split("\n")
    if try_map[insert_y][insert_x] == '.'
      try_map[insert_y][insert_x] = '*'
      check_loop = uniques_or_loop(try_map, guard)
      loops << [insert_y, insert_x] if check_loop == :loop

      # draw_map(try_map)
      # puts "\n#{insert_y + 1} / #{map.length}, #{loops.length} : #{loops}\n"

    end
  end
  print "\xD#{insert_y + 1} / #{map.length}, #{loops.length} "
  # sleep 0.3
end
puts

# puts uniques_or_loop(map, guard)
