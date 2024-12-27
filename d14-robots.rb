# 7
# 0..2
# 4..6

robots = File.readlines(ARGV[0], chomp: true).map do |line|
  line.scan(/[-]?\d+/).map(&:to_i)
end

if robots.length > 30
  W = 101
  H = 103
else
  W = 11
  H = 7
end


# puts(robots[0][2..-1].join(" "), " ")
# print(robots[0][0..1].join(" "))
10000.times do |i|
  xseries = []
  yseries = []
  robots = robots.map do |x, y, dx, dy|
    x = (x + dx) % W
    y = (y + dy) % H
    [x, y, dx, dy]
  end

  # print(" => ", robots[0][0..1].join(" "))
  # if (xseries + yseries).count { |s| s && s > 15} > 3
  # puts robots.count
  # next unless robots.count do |x, y, _, _|
  #   robots.count do |nx, ny, _, _|
      
  #   end
  # end > 3
  picture = []
  H.times { picture << (' ' * W).split('') }
  # puts picture.map(&:join).join("\n")
  robots.each do |x, y, _, _|
    picture[y][x] = '*'
  end
  lines = picture.map(&:join)
  next unless lines.count { |l| l.include?('*' * 20) } > 1
  # puts picture.inspect
  puts
  puts i + 1
  puts
  puts picture.map(&:join).join("\n")
end
# end
# puts
# 


# quadrants = {
#   top: {left: 0, right: 0},
#   bottom: {left: 0, right: 0}
# }

# robots.each do |x, y, _, _|
#   # puts "#{x} #{y}"
#   vert = :middle
#   hor = :middle
#   midvert = H/2
#   midhor = W/2
#   vert = :top if y < midvert
#   vert = :bottom if y > midvert
#   hor = :left if x < midhor
#   hor = :right if x > midhor
#   quadrants[vert][hor] += 1 if quadrants[vert]&.[](hor)
# end
# puts
# puts quadrants
# puts quadrants.values.map(&:values).flatten.reduce(:*)
