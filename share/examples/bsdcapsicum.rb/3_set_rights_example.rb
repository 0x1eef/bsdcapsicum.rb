#!/usr/bin/env ruby
require "bsd/capsicum"

path = File.join(Dir.home, "bsdcapsicum.txt")
file = File.open(path, File::CREAT | File::TRUNC | File::RDWR)
file.sync = true
print "[parent] Obtain file descriptor (with full capabilities)", "\n"
fork do
  BSD::Capsicum.set_rights!(file, %i[read])
  print "[child] Reduce capabilities to read", "\n"

  file.gets
  print "[child] Read OK", "\n"

  begin
    file.write "foo"
  rescue Errno::ENOTCAPABLE => ex
    print "[child] Error: #{ex.message} (#{ex.class})", "\n"
  end
end
Process.wait
file.write "[parent] Hello from #{Process.pid}", "\n"
print "[parent] Write OK", "\n"

##
# [parent] Obtain file descriptor (with full capabilities)
# [child] Reduce capabilities to read
# [child] Read OK
# [child] Error: Capabilities insufficient @ io_write - /home/user/bsdcapsicum.txt (Errno::ENOTCAPABLE)
# [parent] Write OK
