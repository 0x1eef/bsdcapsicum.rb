require "bundler/setup"
require "bsd/capsicum"

print "[parent] In capability mode: ", (BSD::Capsicum.in_capability_mode? ? "yes" : "no"), "\n"
fork do
  print "[subprocess] Enter capability mode: ", (BSD::Capsicum.enter! ? "ok" : "error"), "\n"
  print "[subprocess] In capability mode: ", (BSD::Capsicum.in_capability_mode? ? "yes" : "no"), "\n"
  print "[subprocess] Exit", "\n"
  exit 42
end
Process.wait
print "[parent] In capability mode: ", (BSD::Capsicum.in_capability_mode? ? "yes" : "no"), "\n"

##
# [parent] In capability mode: no
# [subprocess] Enter capability mode: ok
# [subprocess] In capability mode: yes
# [subprocess] Exit
# [parent] In capability mode: no
