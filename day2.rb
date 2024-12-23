require 'scanf'

MIN_STEP = 1
MAX_STEP = 3

def missized_step?(i, j)
  size = (i - j).abs
   size < MIN_STEP || size > MAX_STEP
end

def report_safe(report)
  return :short if report.length < 3
  return :jump if missized_step?(report[0], report[1])
  descending = report[0] > report[1]

  (report.length - 2).times do |idx|
    i, j = report[idx + 1], report[idx + 2]
    return :switch if descending && (i < j)
    return :switch if !descending && (i > j)
    return :jump if missized_step?(i, j)
  end
  return :safe
end

def report_safe_with_tolerance(report)
  return true if report_safe(report) == :safe
  report.length.times do |exclude|
    partial_report = report.reject.with_index { |v,i| i == exclude }
    safe = report_safe(partial_report)
    # puts "#{safe} - #{partial_report}"
    return true if safe == :safe
  end
  return false
end

safe_reports = 0
while next_report = STDIN.gets&.chomp
  levels = []
  next_report.scanf("%d") { |l| levels << l }
  levels.flatten!
  # safe = report_safe(levels)
  # safe_reports += 1  if safe == :safe
  # puts "#{safe} - #{levels}"
  safe_reports += 1 if report_safe_with_tolerance(levels)
end
puts "\n\n\n #{safe_reports} \n\n\n"
