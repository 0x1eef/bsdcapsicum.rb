## About

bsdcapsicum.rb provides Ruby bindings for
[capsicum(4)](https://man.freebsd.org/cgi/man.cgi?query=capsicum&apropos=0&sektion=4&format=html).

## Status

The following functions have an equvialent Ruby interface:

* [x] [cap_enter(2)](https://man.freebsd.org/cgi/man.cgi?query=cap_enter&apropos=0&sektion=2&format=html)
* [x] [cap_getmode(2)](https://man.freebsd.org/cgi/man.cgi?query=cap_getmode&apropos=0&sektion=2&format=html)
* [x] [cap_rights_limit(2)](https://man.freebsd.org/cgi/man.cgi?query=cap_rights_limit&sektion=2&format=html)

The following functions compliment
[cap_rights_limit(2)](https://man.freebsd.org/cgi/man.cgi?query=cap_rights_limit&sektion=2&format=html)
but have not yet been implemented:

* [ ] [cap_ioctls_limit(2)](https://man.freebsd.org/cgi/man.cgi?query=cap_ioctls_limit&sektion=2&format=html)
* [ ] [cap_fcntls_limit(2)](https://man.freebsd.org/cgi/man.cgi?query=cap_fnctls_limit&sektion=2&format=html)

## Examples

__Capability mode__

A process can enter into capability mode by calling
the [BSD::Capsicum.enter!](http://0x1eef.github.io/x/bsdcapsicum.rb/BSD/Capsicum.html#enter!-instance_method)
method. After entering capability mode, the process may	only
issue system calls operating on file descriptors or reading
limited global system state.

File descriptors acquired before entering capability
mode remain fully capable but their capabilites can be reduced. See the
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

__Rights__

The
[BSD::Capsicum.set_rights!](http://0x1eef.github.io/x/bsdcapsicum.rb/BSD/Capsicum.html#set_rights!-instance_method)
method can reduce the capabilities of a file descriptor. The following
example obtains a file descriptor in a parent process (with full capabilities),
then limits the capabilities of the file descriptor
in a child process to allow only read operations. See the
[rights(4)](https://man.freebsd.org/cgi/man.cgi?query=rights&apropos=0&sektion=4&format=html)
and
[cap_rights_limit(2)](https://man.freebsd.org/cgi/man.cgi?query=cap_rights_limit&sektion=2&format=htmlman)
manual pages for more information:

``` ruby
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
