#!/usr/bin/env ruby

# pebbs = STDIN.read.chomp
# pebbs = "125 17"
pebbs = ARGV[0]
PID = Process.pid

def fblink(pebble, file)
  if pebble == "0"
    file.print "1 "
    return 1
  end
  peblen = pebble.length
  if peblen.even?
    half = peblen / 2
    file.print pebble[0..half - 1] + ' '
    file.print pebble[half..-1].to_i.to_s + ' '
    return 2
  end
  file.print (pebble.to_i * 2024).to_s + ' '
  1
end

def blink_file_name(i, rw)
  bit = rw == "r" ?
    i % 2 :
    (i + 1) % 2
  "/tmp/blink.#{PID}.#{bit}"
end

File.open(blink_file_name(-1, "w"), "w") do |pebfile|
  pebfile.print(pebbs + ' ')
end

STDERR.puts

blinks = 75
pebcnt = 0
blinks.times do |i|
  pebble = ''
  pebcnt = 0
  File.open(blink_file_name(i, "w"), "w") do |newf|
    File.open(blink_file_name(i, "r"), "r") do |oldf|
      until oldf.eof? do
        block = oldf.read(1024*1024)
        block.each_char do |c|
          if c != ' '
            pebble += c
          else
            pebcnt += fblink(pebble, newf)
            pebble = ''
          end           
        end
      end
    end
  end
  STDERR.puts "#{PID}\t:: #{i}:#{pebcnt}"
  # pebbs = blink(pebbs)
  # print "\33[2K\r Blink #{i}/#{blinks}: #{pebbs.length}"
end
STDERR.puts
puts pebcnt