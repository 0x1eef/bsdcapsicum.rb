#!/usr/bin/env ruby
require "bsd/capsicum"

path = File.join(Dir.home, "bsdcapsicum.txt")
file = File.open(path, File::CREAT | File::TRUNC | File::RDWR)
file.sync = true
print "[parent] obtain file descriptor (with read+write permissions)", "\n"
fork do
  BSD::Capsicum.set_rights!(file, %i[CAP_READ])
  print "[subprocess] reduce rights to read-only", "\n"

  file.gets
  print "[subprocess] read successful", "\n"

  begin
    file.write "foo"
  rescue Errno::ENOTCAPABLE => ex
    print "[subprocess] Error: #{ex.message} (#{ex.class})", "\n"
  end
end
Process.wait
file.write "[parent] Hello from #{Process.pid}", "\n"
print "[parent] write successful", "\n"

##
# [parent] obtain file descriptor (with read+write permissions)
# [subprocess] reduce rights to read-only
# [subprocess] read successful
# [subprocess] Error: Capabilities insufficient @ io_write - /home/0x1eef/bsdcapsicum.txt (Errno::ENOTCAPABLE)
# [parent] write successful
