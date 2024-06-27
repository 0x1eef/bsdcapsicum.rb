require "bundler/setup"
require "bsd/capsicum"

print "In capability mode: ", (BSD::Capsicum.in_capability_mode? ? "yes" : "no"), "\n"
print "Enter capability mode: ", (BSD::Capsicum.enter! ? "ok" : "error"), "\n"
print "In capability mode: ", (BSD::Capsicum.in_capability_mode? ? "yes" : "no"), "\n"

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
