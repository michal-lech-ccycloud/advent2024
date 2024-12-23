#!/usr/bin/ruby

require "scanf"

def distance(points1, points2)
  sp1 = points1.sort
  sp2 = points2.sort
  dist = 0
  sp1.each_index { |i|  dist += (sp1[i] - sp2[i]).abs }
  dist
end

def similarity(left_l, right_l)
  left_l.map { |l| l * right_l.count { |r| r == l } }.reduce(:+)
end

left_list = []
right_list = []

result = 0
while next_line = STDIN.gets&.chomp do
  left, right = next_line.scanf("%d %d")
  if left
    left_list << left
    right_list << right
  # else
  #   result = similarity(left_list, right_list)
  end
end
# total_distance += distance(left_list, right_list) if left_list.length > 0
result = similarity(left_list, right_list)
puts "\n\n#{result}\n\n"
