everything = File.readlines(ARGV[0], chomp: true)
brkpt = everything.index("")
$map = everything[0..brkpt - 1].map do |l|
  l.gsub('.', ' ').
    gsub('#', '##').
    gsub(' ', '  ').
    gsub('O', '[]').
    gsub('@', '@ ')
end
pregram = everything[brkpt + 1..-1].join

MOVES = {
  "^" => { y: -1, x:  0 },
  ">" => { y:  0, x:  1 },
  "v" => { y:  1, x:  0 },
  "<" => { y:  0, x: -1 }
}

robot_y = $map.index { |l| l.include? '@' }
robot_x = $map[robot_y].index '@'
H = $map.length
W = $map.first.length

pregram.each_char do |cmd|
  direction = MOVES.fetch(cmd)
  x, y = [robot_x, robot_y]
  move_block = []
  if '<>'.include? cmd
    next unless while true do
      x += direction[:x]
      y += direction[:y]
      move_block << [y,x]
      break false if $map[y][x] == '#'
      break true if $map[y][x] == ' '
      raise 'Out of bounds!' if (x < 0) || (y < 0) || ( x >= W) || (y >= H)
    end
    move_block.reverse.each do |y, x|
      $map[y][x] = $map[y - direction[:y]][x - direction[:x]]
    end
  else
    move_block = { robot_y => [robot_x] }
    # move_block[robot_y] = [robot_x]
    # Skip to next command of while true ends/breaks
    next unless
      while true do
        move_block[y].sort!.uniq!
        ny = y + direction[:y]
        all_clear = true
        # Only blocks already in move_block can affect next line
        break false unless move_block[y].each do |x|
          # Free space in last line, nothing to affect the next line
          next true if $map[y][x] == ' '
          # A box or robot is blocked by wall
          break false if $map[ny][x] == '#'
          # A box or robot pushes [into] the next line
          all_clear = false
          (move_block[ny] ||= []) << x
          case $map[ny][x]
          when " ";;
          when "]"; move_block[ny] << x - 1;
          when "["; move_block[ny] << x + 1;
          else
            raise "Unexpected block #{$map[ny][x]}"
          end
          true
        end
        break true if all_clear
        y = ny
      end
    until y == robot_y
      ny = y - direction[:y]
      move_block[y].each do |x|
        next unless move_block[ny].include? x
        $map[y][x] = $map[ny][x]
        $map[ny][x] = ' '
      end
      y = ny
    end  
  end
  $map[robot_y][robot_x] = ' '
  robot_x += direction[:x]
  robot_y += direction[:y]
  # puts "\033[2J\033[0;0H" + $map.join("\n")
  exit if $map.any? { |l| l =~ / \]|\[ / }
  # sleep 0.1
  # STDIN.gets
end

gps_sum = 0
H.times do |y|
  W.times do |x|
    # gps_sum += 100 * y + x if $map[y][x] == 'O'
    gps_sum += 100 * y + x if $map[y][x] == '['
  end
end
puts gps_sum


# puts moves.inspect