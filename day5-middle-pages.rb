rules = {}
# updates = []

phase = :rules

def update_compliant?(update, rules)
  rules.all? do |predecessor, successors|
    successors.all? do |succ|
      isucc = update.index(succ)
      ipred = update.index(predecessor)
      isucc.nil? || ipred.nil? || isucc > ipred
    end
  end
end

sum_of_mids = 0
while next_line = STDIN.gets&.chomp do
  next phase = :updates if next_line == ""
  if phase == :rules
    predecessor, successor = next_line.split('|')
    (rules[predecessor] ||= []) << successor
    next
  end
  update = next_line.split(",")
  upd_len = update.length
  raise "Broken update #{next_line}" unless upd_len.odd?
  next unless update_compliant?(update, rules)
  mid = update[upd_len / 2]
  sum_of_mids += mid.to_i
end

puts sum_of_mids
