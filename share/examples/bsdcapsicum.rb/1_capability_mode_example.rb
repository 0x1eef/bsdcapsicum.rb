require "bundler/setup"
require "bsd/capsicum"

print "In capability mode: ", (BSD::Capsicum.capability_mode? ? "yes" : "no"), "\n"
BSD::Capsicum.enter_capability_mode!
print "Enter capability mode: ok", "\n"
print "In capability mode: ", (BSD::Capsicum.capability_mode? ? "yes" : "no"), "\n"

begin
  File.new(File::NULL)
rescue Errno::ECAPMODE => ex
  print "Error: #{ex.message} (#{ex.class})", "\n"
end

##
# In capability mode: no
# Enter capability mode: ok
# In capability mode: yes
# Error: Not permitted in capability mode @ rb_sysopen - /dev/null (Errno::ECAPMODE)
