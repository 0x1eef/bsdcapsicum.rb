#!/usr/bin/env ruby
require "bsd/capsicum"
require "tmpdir"
require "fcntl"

path = File.join(Dir.tmpdir, "bsdcapsicum.txt")
file = File.open(path, File::CREAT | File::TRUNC | File::RDWR)
file.sync = true
print "Obtain file descriptor (with full capabilities)", "\n"

file.permit!(:fcntl)
print "Reduce capabilities to fcntl", "\n"

file.permit!(:GETFL, scope: :fcntl)
print "Reduces fcntl capabilties to GETFL", "\n"

flags = file.fcntl(Fcntl::F_GETFL)
print "Get fcntl flags: OK", "\n"

begin
  print "Try to set fcntls flag ... ", "\n"
  file.fcntl(Fcntl::F_SETFL, flags | Fcntl::O_APPEND)
rescue Errno::ENOTCAPABLE => ex
  print "Error: #{ex.message} (#{ex.class})", "\n"
end

##
# Obtain file descriptor (with full capabilities)
# Reduce capabilities to fcntl
# Reduce fcntl capabilties to fcntl_getfl
# Get fcntl flags: OK
# Try to set fcntls flag ...
# Error: Capabilities insufficient @ finish_narg - /tmp/bsdcapsicum.txt (Errno::ENOTCAPABLE)
