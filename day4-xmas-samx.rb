$xmas = STDIN.read.split("\n")
$is_in_an_xmas = $xmas.map { |line| line.split("").map { |_| false} }

$counters = {
  right: 0, left: 0, up: 0, down: 0,
  diagDR: 0, diagUL: 0, diagDL: 0, diagUR: 0,
  snek: 0
}

PHRASE = 'XMAS'
# $search_phrase = 'MASSM'
# MARGIN = PHRASE.length - 1
MARGIN = 2
def check_offsets(offsets, search4 = PHRASE)
  puts offsets
  phrases = offsets.map do |direction, offset_series|
    [ direction,
      offset_series.map { |y, x| $xmas[y][x] }.join ]
  end.to_h
  puts phrases
  phrases.each_pair do |direction, phrase|
    if phrase == search4
      $counters[direction] += 1
      offsets[direction].each { |y,x| $is_in_an_xmas[y][x] = true }
    end
  end
end

# ($xmas.length - MARGIN).times do |y0|
#   ($xmas.first.length).times do |x0|
#     offsets = {
#       down:   (0..MARGIN).map { |i| [y0 + i         , x0 ] },
#       up:     (0..MARGIN).map { |i| [y0 + MARGIN - i, x0 ] },
#     }
#     check_offsets offsets
#   end
# end

# ($xmas.length).times do |y0|
#   ($xmas.first.length - MARGIN).times do |x0|
#     offsets = {
#       right:  (0..MARGIN).map { |i| [y0 , x0 + i         ] },
#       left:   (0..MARGIN).map { |i| [y0 , x0 + MARGIN - i] },
#     }
#     check_offsets offsets
#   end
# end

# ($xmas.length - MARGIN).times do |y0|
#   ($xmas.first.length - MARGIN).times do |x0|
#     offsets = {
#       diagDR: (0..MARGIN).map { |i| [y0 + i         , x0 + i         ] },
#       diagDL: (0..MARGIN).map { |i| [y0 + i         , x0 + MARGIN - i] },
#       diagUR: (0..MARGIN).map { |i| [y0 + MARGIN - i, x0 + i         ] },
#       diagUL: (0..MARGIN).map { |i| [y0 + MARGIN - i, x0 + MARGIN - i] }
#     }
#     check_offsets offsets
#   end
# end

# M S
#  A
# M S
# 
# MASSM
# 
# M M
#  A
# S S
# 
# MASMS
#
# S S
#  A
# M M
# 
# SAMSM
# 
# S M
#  A
# S M
# 
# SAMMS


%w(MASSM MASMS SAMSM SAMMS).each do |coil|
  ($xmas.length - MARGIN).times do |y0|
    ($xmas.first.length - MARGIN).times do |x0|
      offsets = {
        snek: [
          [y0 + 0, x0 + 0],
          [y0 + 1, x0 + 1],
          [y0 + 2, x0 + 2],
          [y0 + 0, x0 + 2],
          [y0 + 2, x0 + 0]
        ]
      }
      check_offsets offsets, coil
    end
  end    
end


$is_in_an_xmas.each_index do |y|
  $is_in_an_xmas.first.each_index { |x| print $is_in_an_xmas[y][x] ? $xmas[y][x] : '.' }
  puts
end

# puts $counters
puts "Total: #{$counters.values.reduce(:+)}"