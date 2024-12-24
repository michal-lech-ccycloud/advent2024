antennas = {}
w = 0
y = 0
while next_line = STDIN.gets&.chomp do
  w = next_line.length
  next_line.split("").each_with_index do |c, x|
    (antennas[c] ||= []) << [x,y] if c != '.'
  end
  y += 1
end
h = y

puts antennas.keys.join

antinodes = []
antennas.each_pair do |freq, freq_ants|
  print " #{freq}: #{freq_ants.length}"
  next unless freq_ants.length > 1
  ants = [*freq_ants]
  while ants.length > 1 do
    x1, y1 = ants.shift
    antinodes << [x1, y1] unless antinodes.include? [x1, y1]
    ants.each do |x2, y2|
      antinodes << [x2, y2] unless antinodes.include? [x2, y2]
      xshift = x2 - x1
      yshift = y2 - y1
      ax, ay = [x1, y1]
      while true do
        ax -= xshift
        ay -= yshift
        break if ax < 0 || ay < 0
        break unless ax < w && ay < h
        antinodes << [ax, ay] unless antinodes.include? [ax, ay]
      end
      ax, ay = [x2, y2]
      while true do
        ax += xshift
        ay += yshift
        break if ax < 0 || ay < 0
        break unless ax < w && ay < h
        antinodes << [ax, ay] unless antinodes.include? [ax, ay]
      end
      print "\33[2K\r #{freq}: #{ants.length} / #{freq_ants.length} "
    end
  end
end

# puts w: w, h: h, antennas: antennas, antinodes: antinodes
puts antinodes.length