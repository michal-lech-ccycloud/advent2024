def next_operator_combo(combo)
  glued = combo.join
  return :no_more unless glued.include?("+")

  conv = glued.gsub('+','0').gsub('*','1').to_i(2)
  (conv + 1).to_s(2).gsub('0','+').gsub('1','*').rjust(combo.length, '+').split('')
end

def can_match?(expect, initial_numbers)
  operators = Array.new(initial_numbers.length - 1, '+')
  until operators == :no_more do
    numbers = [*initial_numbers]    
    result = numbers.shift
    script = numbers.zip(operators)
    script.each do |num, oper|
      raise "Can't calculate #{script}" unless "*+".include? oper

      result = oper == '+' ? result + num : result * num
    end
    return true if result == expect
    operators = next_operator_combo(operators)
  end
  false
end

total_calibration = 0
while next_line = STDIN.gets&.chomp do
  expected, numbers = next_line.split ': '
  expected = expected.to_i
  numbers = numbers.split(' ').map(&:to_i)
  # puts next_line
  # puts "#{expected}: #{numbers}"
  total_calibration += expected if can_match?(expected, numbers) 
end
puts total_calibration