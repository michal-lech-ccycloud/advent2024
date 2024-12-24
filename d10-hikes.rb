$score_sum = 0

MOVES = [
  [ 0,  1], # right
  [ 0, -1], # left
  [ 1,  0], # down
  [-1,  0]  # up
]
$map = STDIN.read.split("\n").map { |line| line.split("").map(&:to_i) }

$w = $map.length
$h = $map.first.length


def check_endpoints(y, x, e, eps)
  if e == 9
    # puts (trail + [[y,x,e]]).inspect
    # return $score_sum += 1
    eps << [y,x]
    return
  end
  MOVES.each do |dy, dx|
    ay = y + dy
    ax = x + dx
    next if ax < 0 || ay < 0
    next unless ax < $w && ay < $h
    new_e = $map[ay][ax]
    next unless new_e - e == 1
    check_endpoints(ay, ax, new_e, eps)
  end
end

puts

$map.each_index do |start_y|
  $map.first.each_index do |start_x|
    next unless $map[start_y][start_x] == 0
    # print "\33[2K\rChecking trails from [#{start_x}/#{$w}, #{start_y}/#{$h}]"
    print "\33[2K\rChecking trails from [#{start_y}/#{$h}, #{start_x}/#{$w}]; score: "
    # puts "Checking trails from [#{start_y}/#{$h}, #{start_x}/#{$w}]"
    endpoints = []
    check_endpoints(start_y, start_x, 0, endpoints)
    score = endpoints.length
    print score
    $score_sum += score
  end
end

puts
puts $score_sum