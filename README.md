## About

bsdcapsicum.rb provides Ruby bindings for
[capsicum(4)](https://man.freebsd.org/cgi/man.cgi?query=capsicum&apropos=0&sektion=4&format=html).

## Examples

__Capability mode__

A process can enter into capability mode by calling
the [BSD::Capsicum.enter!](http://0x1eef.github.io/x/bsdcapsicum.rb/BSD/Capsicum.html#enter!-instance_method)
method. After entering capability mode, the process has limited
abilities. File descriptors acquired before entering capability 
mode remain accessible and unrestricted, but their capabilites 
can be reduced. See the
[cap_enter(2)](https://man.freebsd.org/cgi/man.cgi?query=cap_enter&apropos=0&sektion=2&format=html)
manual page for more details:

```ruby
#!/usr/bin/env ruby
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
```

__Child process__

By spawning a child process and then entering capability mode, restrictions can be
limited to a child process (and its child processes, if any). This can be helpful in
an architecture where a parent process can spawn one or more child processes to handle
certain tasks but with restrictions in place:

```ruby
#!/usr/bin/env ruby
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
```

__Rights__

The
[BSD::Capsicum.set_rights!](http://0x1eef.github.io/x/bsdcapsicum.rb/BSD/Capsicum.html#set_rights!-instance_method)
method can reduce the capabilities of a file descriptor. The following
example obtains a file descriptor in a parent process (with full capabilities),
then limits the capabilities of the file descriptor
in a child process to allow only read operations. See the
[rights(4)](https://man.freebsd.org/cgi/man.cgi?query=rights&apropos=0&sektion=4&format=html)
man page for a full list of capabilities:

``` ruby
#!/usr/bin/env ruby
require "bsd/capsicum"

path = File.join(Dir.home, "bsdcapsicum.txt")
file = File.open(path, File::CREAT | File::TRUNC | File::RDWR)
file.sync = true
print "[parent] Obtain file descriptor (with all capabilities)", "\n"
fork do
  BSD::Capsicum.set_rights!(file, %i[CAP_READ])
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
# [parent] Obtain file descriptor (with all capabilities)
# [child] Reduce capabilities to read
# [child] Read OK
# [child] Error: Capabilities insufficient @ io_write - /home/user/bsdcapsicum.txt (Errno::ENOTCAPABLE)
# [parent] Write OK
```

## Documentation

A complete API reference is available at [0x1eef.github.io/x/bsdcapsicum.rb](https://0x1eef.github.io/x/bsdcapsicum.rb)

## Install

bsdcapsicum.rb is available via rubygems.org:

    gem install bsdcapsicum.rb

## Sources

* [GitHub](https://github.com/0x1eef/bsdcapsicum.rb#readme)
* [GitLab](https://gitlab.com/0x1eef/bsdcapsicum.rb#about)
* [git.HardenedBSD.org/@0x1eef](https://git.hardenedbsd.org/0x1eef/bsdcapsicum.rb#about)
* [brew.bsd.cafe/@0x1eef](https://brew.bsd.cafe/0x1eef/bsdcapsicum.rb)

## See also

* [Freaky/ruby-capsicum](https://github.com/Freaky/ruby-capsicum) <br>
  bsdcapsicum.rb is a fork of this project. It was a huge help both
  in terms of code and documentation.

## License

bsdcapsicum.rb
<br>
[BSD Zero Clause](https://choosealicense.com/licenses/0bsd/)
<br>
See [LICENSE](./LICENSE)
<br><br>
ruby-capsicum
<br>
[Freaky/ruby-capsicum](https://github.com/Freaky/ruby-capsicum) is released
under the terms of the MIT license
<br>
See [LICENSE.ruby-capsicum](/.LICENSE-ruby-capsicum)
