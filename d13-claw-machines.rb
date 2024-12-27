machines = File.readlines(ARGV[0], chomp: true)
total_minimum = 0

def equivalent_buttons?(ax, ay, bx, by)
  aybx = ay * bx
  return false unless aybx % by == 0
  aybx / by == ax
end

while machines.length > 0 do
  a_button_str = machines.shift
  b_button_str = machines.shift
  prize_str = machines.shift
  machines.shift

  ax, ay = a_button_str.scan(/\d+/).map(&:to_i)
  bx, by = b_button_str.scan(/\d+/).map(&:to_i)
  px, py =    prize_str.scan(/\d+/).map(&:to_i).map { |c| c + 10000000000000 }

  # A_presses = Integer * B_presses or vice_versa
  if equivalent_buttons?(ax, ay, bx, by)    
    p_a_x_rem = px % ax
    p_b_x_rem = px % bx
    p_a_y_rem = py % ay
    p_b_y_rem = py % by

    # Can't get to prize with A button
    if (p_a_x_rem != 0) || (p_a_y_rem != 0)
      if (p_b_x_rem == 0) && (p_b_y_rem == 0)
        total_minimum += px / bx
        puts "[#{px}, #{py}], A:[#{ax}, #{ay}], B:[#{bx}, #{by}]"
      end
      next
    end

    # Can't get to prize with B button
    if (p_b_x_rem != 0) || (p_b_y_rem != 0)
      if (p_a_x_rem == 0) && (p_a_y_rem == 0)
        total_minimum += 3 * px / ax
        puts "[#{px}, #{py}], A:[#{ax}, #{ay}], B:[#{bx}, #{by}]"
      end
      next
    end
    
    # Each button will hit prize, choose cheaper (can be equal cost)
    a_cost = 3 * px / ax
    b_cost = px / bx
    total_minimum += a_cost < b_cost ? a_cost : b_cost
    puts "[#{px}, #{py}], A:[#{ax}, #{ay}], B:[#{bx}, #{by}]"
  end

  # Linear equation set. Lines will cross once, but not necessarily at
  # the integer prize coordinates
  # 
  # PA * ax + PB * bx = px
  # PA * ay + PB * by = py
  # 
  # PB = (ax * py - ay * px) / (ax * by - ay * bx)
  # PA = (px - PB * bx) / ax 
  axpy_aypx = ax * py - ay * px
  axby_aybx = ax * by - ay * bx
  # Must have an integer number of B presses
  next unless axpy_aypx % axby_aybx == 0
  b_presses = axpy_aypx / axby_aybx
  # Must have an integer number of A presses
  px_pbbx = px - b_presses * bx
  next unless px_pbbx % ax == 0
  a_presses = px_pbbx / ax
  total_minimum += 3 * a_presses + b_presses
  puts "[#{px}, #{py}], A:[#{ax}, #{ay}], B:[#{bx}, #{by}]"
end

puts total_minimum