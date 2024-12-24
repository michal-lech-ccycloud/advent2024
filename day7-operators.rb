OPERATORS = '+*|'

def next_operator_combo(combo, operset)
  glued = combo.join
  base = operset.length
  return :no_more if glued == operset[base - 1] * glued.length
  conv = glued
  operset.split("").each_with_index { |o, i| conv = conv.gsub(o, i.to_s) }
  conv = conv.to_i(base)
  next_combo = (conv + 1).to_s(base)
  operset.split("").
    each_with_index { |o, i| next_combo = next_combo.gsub(i.to_s, o) }
  next_combo.rjust(combo.length, operset[0]).split('')
end

def can_match?(expect, initial_numbers)
  operators = Array.new(initial_numbers.length - 1, '+')
  until operators == :no_more do
    numbers = [*initial_numbers]    
    result = numbers.shift
    script = numbers.zip(operators)
    script.each do |num, oper|
      case oper
      when '+'
        result += num
      when '*'
        result *= num
      when '|'
        result = (result.to_s + num.to_s).to_i
      else
        raise "Can't calculate #{script}"
      end
    end
    return true if result == expect
    operators = next_operator_combo(operators, '+*|')
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
  print '.'
end
puts
puts total_calibration