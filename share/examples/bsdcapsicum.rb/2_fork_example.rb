require "bundler/setup"
require "bsd/capsicum"

print "[parent] In capability mode: ", (BSD::Capsicum.in_capability_mode? ? "yes" : "no"), "\n"
fork do
  print "[child] Enter capability mode: ", (BSD::Capsicum.enter! ? "ok" : "error"), "\n"
  print "[child] In capability mode: ", (BSD::Capsicum.in_capability_mode? ? "yes" : "no"), "\n"
  print "[child] Exit", "\n"
  exit 42
end
Process.wait
print "[parent] In capability mode: ", (BSD::Capsicum.in_capability_mode? ? "yes" : "no"), "\n"

##
# [parent] In capability mode: no
# [child] Enter capability mode: ok
# [child] In capability mode: yes
# [child] Exit
# [parent] In capability mode: no
