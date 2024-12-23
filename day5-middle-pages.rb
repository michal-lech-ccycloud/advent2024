$rules = {}
# updates = []

phase = :rules

def update_compliant?(update)
  $rules.all? do |predecessor, successors|
    successors.all? do |succ|
      isucc = update.index(succ)
      ipred = update.index(predecessor)
      isucc.nil? || ipred.nil? || isucc > ipred
    end
  end
end

def compare_by_rules(a, b)
  succs_of_a = $rules[a]
  succs_of_b = $rules[b]
  return -1 if succs_of_a&.include? b
  return  1 if succs_of_b&.include? a
  return 0
end

def apply_rules(update)
  update.sort(&method(:compare_by_rules))
end

sum_of_mids = 0
while next_line = STDIN.gets&.chomp do
  next phase = :updates if next_line == ""
  if phase == :rules
    predecessor, successor = next_line.split('|')
    ($rules[predecessor] ||= []) << successor
    next
  end
  update = next_line.split(",")
  upd_len = update.length
  raise "Broken update #{next_line}" unless upd_len.odd?
  # next unless update_compliant?(update, rules)
  next if update_compliant?(update)
  update = apply_rules(update)
  raise "Can't sort!" unless update_compliant?(update)
  mid = update[upd_len / 2]
  sum_of_mids += mid.to_i
end

puts sum_of_mids
