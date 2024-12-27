=begin

...XX.... ...11....
....X.... ....1....
.XXXX.... .2221....
.X....XX. .2....33.
.X.....X. .2.....3.
.XXXXXXX. .2222223.
......... .........

XXXXXX XXXX
X    X X  X
X XX X XX X
X  X X    X
XXXX XXXXXX
       
111111 2222
1    1 2  2
1 33 1 22 2
1  3 1    2
1111 111111
  


=end

require 'pry-nav'

$plots = File.readlines(ARGV[0], chomp: true).map { |line| line.split "" }

# puts $field.map { |l| l.join }.join("\n")

$regions = []
$h = $plots.length
$w = $plots.first.length

def get_plot(v)
  y, x = v
  return nil if y < 0 || x < 0
  return nil unless y < $h && x < $w
  $plots[y][x]
end

def check_earlier_neighbour(plot, my_crop, my_fences)
  return [nil, my_fences + 1] unless plot
  old_region = plot
  return [nil, my_fences + 1] unless old_region[:crop] == my_crop
  return [old_region, my_fences]
end

def check_indirect_region(y, x, crop, path)
  # return $plots[y][x] if $regions.include? $plots[y][x]
  current = $plots[y][x]
  path << [y, x]
  # path.map { |y,x| "#{cur}" }
  [[y - 1, x], [y, x - 1], [y + 1, x], [y, x + 1]].each do |ny, nx|
    next if path.include? [ny, nx]
    neighb = get_plot([ny, nx])
    next unless neighb
      
    if neighb.class == String
      if neighb == current
        recurse = check_indirect_region(ny, nx, crop, path)
        return recurse if recurse
      end
    else
      return neighb if neighb[:crop] == current
    end    
  end
  return nil
end

$h.times do |y|
  $w.times do |x|
    crop_here = $plots[y][x]
    # print crop_here
    new_fences = 0
    # my_region = nil
    up, left, down, right = [[y - 1, x], [y, x - 1],
                             [y + 1, x], [y, x + 1]].map(&method('get_plot'))
    # binding.pry if (y == 0 && x == 0) || (y == 1 && x == 0)
    region_u, new_fences = check_earlier_neighbour(up, crop_here, new_fences)
    region_l, new_fences = check_earlier_neighbour(left, crop_here, new_fences)
    # snakey_region = 
    unless region = region_u || region_l || check_indirect_region(y, x, crop_here, [])
      region = {
        y: y, x: x, size: 0, crop: crop_here,
        # perimeter: 0
        sides: { vert: 0, hor: 0 }
      }
      $regions << region
    end
    region[:size] += 1
    # region[:perimeter] += new_fences
    $plots[y][x] = region
    # region[:perimeter] += 1 unless right == crop_here
    # region[:perimeter] += 1 unless down == crop_here
  end
  # puts
end



# puts $regions.map { |r| "#{r[:crop]} x #{r[:size]} (#{r[:perimeter]}) @ [#{r[:y] + 1}, #{r[:x] + 1}]" }.join("\n")

# puts $regions.map { |r| r[:size] * r[:perimeter] }.reduce(:+)
# 

# $regions.each do |r|
#   r[:sides] = {
#     vert: 0, hor: 0
#   }    
# end

($h + 1).times do |y|
  prev_up = nil
  prev_lo = nil
  $w.times do |x|
    upper = get_plot([y - 1, x])
    lower = get_plot([y, x])
    if upper != lower      
      upper[:sides][:hor] += 1 if upper && (upper != prev_up || upper == prev_lo)
      lower[:sides][:hor] += 1 if lower && (lower != prev_lo || lower == prev_up)
    end
    prev_up = upper
    prev_lo = lower
  end
end

($w + 1).times do |x|
  prev_left = nil
  prev_right = nil
  $h.times do |y|
    left =  get_plot([y, x - 1])
    right = get_plot([y, x])
    if left != right
      left[:sides][:vert] += 1 if left && (left != prev_left || left == prev_right)
      right[:sides][:vert] += 1 if right && (right != prev_right || right == prev_left)
    end
    prev_left = left
    prev_right = right
  end
end

puts $regions.map { |r| "#{r[:crop]} x #{r[:size]} (#{r[:sides].values.reduce(:+)}) @ [#{r[:y] + 1}, #{r[:x] + 1}]" }.join("\n")

puts $regions.map { |r| r[:size] * r[:sides].values.reduce(:+) }.reduce(:+)
