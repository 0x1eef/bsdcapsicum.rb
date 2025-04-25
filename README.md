## About

bsdcapsicum.rb provides Ruby bindings for FreeBSD's
[capsicum(4)](https://man.freebsd.org/cgi/man.cgi?query=capsicum&apropos=0&sektion=4&format=html)
via
[fiddle](https://github.com/ruby/fiddle#readme).

The capsicum framework provides a sandbox model where a process can enter
into a mode of operation where it is exclusively capable of performing system
calls on file descriptors that have been acquired before entering capability
mode.

The file descriptors can also be limited to a subset of system calls, and
a file descriptor could reference a file, a socket, or other IO objects.
Both of these strategies can be used together to limit the capabilities
of a process and / or to limit the capabilities of file descriptors.

## Examples

### BSD::Capsicum

#### Capability mode

A process can enter into capability mode by calling
the
[BSD::Capsicum.enter_capability_mode!](http://0x1eef.github.io/x/bsdcapsicum.rb/BSD/Capsicum.html#enter!-instance_method)
method. After entering capability mode, a process may only
issue system calls operating on file descriptors that have already
been acquired or by reading limited global system state.
File descriptors acquired before entering capability mode remain
fully capable but their capabilities can be reduced by calling
the
[BSD::Capsicum.permit!](http://0x1eef.github.io/x/bsdcapsicum.rb/BSD/Capsicum.html#permit!-instance_method)
method. See the
[cap_enter(2)](https://man.freebsd.org/cgi/man.cgi?query=cap_enter&apropos=0&sektion=2&format=html)
manual page or the rest of the README for more details:

```ruby
#!/usr/bin/env ruby
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
```

#### File descriptors

The
[BSD::Capsicum::IO#permit!](http://0x1eef.github.io/x/bsdcapsicum.rb/BSD/Capsicum/IO.html#permit!-instance_method)
method can reduce the capabilities of a file descriptor by limiting what
system calls it can be used with. In that sense it is roughly similar to OpenBSD's
pledge but it operates on the file descriptor level rather than the process
level.
The following example obtains a file descriptor in a parent process (with
full capabilities), then limits the capabilities of the file descriptor
in a child process to allow only read operations. See the
[rights(4)](https://man.freebsd.org/cgi/man.cgi?query=rights&apropos=0&sektion=4&format=html)
and
[cap_rights_limit(2)](https://man.freebsd.org/cgi/man.cgi?query=cap_rights_limit&sektion=2&format=htmlman)
manual pages for more information:

``` ruby
#!/usr/bin/env ruby
require "bsd/capsicum"
require "tmpdir"

path = File.join(Dir.tmpdir, "bsdcapsicum.txt")
file = File.open(path, File::CREAT | File::TRUNC | File::RDWR)
file.sync = true
print "[parent] Obtain file descriptor (with full capabilities)", "\n"
fork do
  file.permit!(:read)
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
# [child] Error: Capabilities insufficient @ io_write - /tmp/bsdcapsicum.txt (Errno::ENOTCAPABLE)
# [parent] Write OK
```

#### Fcntls

The
[BSD::Capsicum::IO#permit!](http://0x1eef.github.io/x/bsdcapsicum.rb/BSD/Capsicum/IO.html#permit!-instance_method)
method can limit the fcntl capabilities of a file descriptor by limiting what
fcntl operations it can be used with. This method requires the fcntl capability to already
be present, and it can limit fcntl operations to a smaller subset of operations.
The following example limits the fcntl capabilities of a file descriptor to allow
only the `GETFL` operation, and prevents the `SETFL` operation:

```ruby
#!/usr/bin/env ruby
require "bsd/capsicum"
require "tmpdir"

path = File.join(Dir.tmpdir, "bsdcapsicum.txt")
file = File.open(path, File::CREAT | File::TRUNC | File::RDWR)
file.sync = true
print "Obtain file descriptor (with full capabilities)", "\n"

file.permit!(:fcntl)
print "Reduce capabilities to fcntl", "\n"

file.permit!(:GETFL, scope: :fcntl)
print "Reduces fcntl capabilities to GETFL", "\n"

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
# Reduce fcntl capabilities to fcntl_getfl
# Get fcntl flags: OK
# Try to set fcntls flag ...
# Error: Capabilities insufficient @ finish_narg - /tmp/bsdcapsicum.txt (Errno::ENOTCAPABLE)
```

## Documentation

A complete API reference is available at [0x1eef.github.io/x/bsdcapsicum.rb](https://0x1eef.github.io/x/bsdcapsicum.rb)

## Install

bsdcapsicum.rb is available via rubygems.org:

    gem install bsdcapsicum.rb

## Sources

* [github.com/@0x1eef](https://github.com/0x1eef/bsdcapsicum.rb#readme)
* [gitlab.com/@0x1eef](https://gitlab.com/0x1eef/bsdcapsicum.rb#about)
* [git.HardenedBSD.org/@0x1eef](https://git.hardenedbsd.org/0x1eef/bsdcapsicum.rb#about)
* [bsd.cafe/@0x1eef](https://brew.bsd.cafe/0x1eef/bsdcapsicum.rb)

## See also

* [Freaky/ruby-capsicum](https://github.com/Freaky/ruby-capsicum) <br>
  bsdcapsicum.rb is a fork of this project.

## Status

The following functions have an equivalent Ruby interface:

* [x] [cap_enter(2)](https://man.freebsd.org/cgi/man.cgi?query=cap_enter&apropos=0&sektion=2&format=html)
* [x] [cap_getmode(2)](https://man.freebsd.org/cgi/man.cgi?query=cap_getmode&apropos=0&sektion=2&format=html)
* [x] [cap_rights_limit(2)](https://man.freebsd.org/cgi/man.cgi?query=cap_rights_limit&sektion=2&format=html)
* [x] [cap_fcntls_limit(2)](https://man.freebsd.org/cgi/man.cgi?query=cap_fcntls_limit&sektion=2&format=html)

The following functions complement
[cap_rights_limit(2)](https://man.freebsd.org/cgi/man.cgi?query=cap_rights_limit&sektion=2&format=html)
but have not yet been implemented:

* [ ] [cap_ioctls_limit(2)](https://man.freebsd.org/cgi/man.cgi?query=cap_ioctls_limit&sektion=2&format=html)

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
