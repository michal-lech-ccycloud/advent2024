everything = File.readlines(ARGV[0], chomp: true)
brkpt = everything.index("")
$map = everything[0..brkpt - 1].map { |l| l.gsub('.', ' ') }
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
  $map[robot_y][robot_x] = ' '
  robot_x += direction[:x]
  robot_y += direction[:y]
  # puts "\033[2J\033[0;0H" + $map.join("\n")
  # sleep 0.1
end

gps_sum = 0
H.times do |y|
  W.times do |x|
    gps_sum += 100 * y + x if $map[y][x] == 'O'
  end
end
puts gps_sum


# puts moves.inspect