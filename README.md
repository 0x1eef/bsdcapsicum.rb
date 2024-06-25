## About

bsdcapsicum.rb provides Ruby bindings for the
[capsicum(4)](https://man.freebsd.org/cgi/man.cgi?query=capsicum&apropos=0&sektion=4&format=html)
feature that's available on FreeBSD.

## Examples

__Capability mode__

A process can enter into capability mode by calling
[BSD::Capsicum.enter!](http://0x1eef.github.io/x/bsdcapsicum.rb/BSD/Capsicum.html#enter!-instance_method).
After entering capability mode, the process has limited
capabilities. See the
[cap_enter(2)](https://man.freebsd.org/cgi/man.cgi?query=cap_enter&apropos=0&sektion=2&format=html)
manual page for more details:

```ruby
require "bsd/capsicum"

print "In capability mode: ", BSD::Capsicum.in_capability_mode? ? "yes" : "no", "\n"
print "Enter capability mode: ", BSD::Capsicum.enter! ? "ok" : "error", "\n"
print "In capability mode: ", BSD::Capsicum.in_capability_mode? ? "yes" : "no", "\n"

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
```

__IPC__

By spawning a child process and then entering capability mode, restrictions can be
limited to a child process (and its child processes, if any). This can be helpful in
an architecture where a parent process can spawn one or more child processes to handle
certain tasks but with restrictions in place:

```ruby
require "bsd/capsicum"

print "[parent] In capability mode: ", BSD::Capsicum.in_capability_mode? ? "yes" : "no", "\n"
fork do
  print "[subprocess] Enter capability mode: ", BSD::Capsicum.enter! ? "ok" : "error", "\n"
  print "[subprocess] In capability mode: ", BSD::Capsicum.in_capability_mode? ? "yes" : "no", "\n"
  print "[subprocess] Exit", "\n"
  exit 42
end
Process.wait
print "[parent] In capability mode: ", BSD::Capsicum.in_capability_mode? ? "yes" : "no", "\n"

##
# [parent] In capability mode: no
# [subprocess] Enter capability mode: ok
# [subprocess] In capability mode: yes
# [subprocess] Exit
# [parent] In capability mode: no
```

## Documentation

A complete API reference is available at [0x1eef.github.io/x/bsdcapsicum.rb](https://0x1eef.github.io/x/bsdcapsicum.rb)

## Install

bsdcapsicum.rb is available via rubygems.org:

    gem install bsdcapsicum.rb

## See also

* [Freaky/ruby-capsicum](https://github.com/Freaky/ruby-capsicum) <br>
  bsdcapsicum.rb is a fork of this project. It was a huge help both
  in terms of code and documentation.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

