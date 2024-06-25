# Capsicum

A simple FFI wrapper around the [Capsicum](https://wiki.freebsd.org/Capsicum)
OS capability and sandbox framework.


## Installation

A Capsicum-enabled OS is, of course, required.  FreeBSD 10+ (or derivative),
possibly [capsicum-linux](http://capsicum-linux.org/).

Add this line to your application's Gemfile:

```ruby
gem 'capsicum'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capsicum


## Usage

Basic synopsis:

```ruby
require "capsicum"

print "In capability mode: ", Capsicum.in_capability_mode? ? "yes" : "no", "\n"
print "Enter capability mode: ", Capsicum.enter! ? "ok" : "error", "\n"
print "In capability mode: ", Capsicum.in_capability_mode? ? "yes" : "no", "\n"

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

i.e. anything that involves opening a file, connecting a socket, or executing a
program is verboten.  Kinda.

On fork-capable Rubies, you can also do this:

```ruby
require "capsicum"

print "[parent] In capability mode: ", Capsicum.in_capability_mode? ? "yes" : "no", "\n"
fork do
  print "[subprocess] Enter capability mode: ", Capsicum.enter! ? "ok" : "error", "\n"
  print "[subprocess] In capability mode: ", Capsicum.in_capability_mode? ? "yes" : "no", "\n"
  print "[subprocess] Exit", "\n"
  exit 42
end
Process.wait
print "[parent] In capability mode: ", Capsicum.in_capability_mode? ? "yes" : "no", "\n"

##
# [parent] In capability mode: no
# [subprocess] Enter capability mode: ok
# [subprocess] In capability mode: yes
# [subprocess] Exit
# [parent] In capability mode: no
```

## But How Can I Get Anything Done?

Open your files and sockets before the current process enters capability mode.
If you have a `TCPServer` open, for example, you can still call `#accept` on it,
so a useful server could conceivably run within it.

You *can* open new files, but this requires access to *at() syscalls.  If Ruby
supported them, it might look something like this:

```ruby
dir = Dir.open("/path/to/my/files")

Capsicum.enter!

file = File.openat(dir, "mylovelyfile")
File.renameat(dir, "foo", dir, "bar")
File.unlinkat(dir, "moo")
```

Unfortunately, it doesn't.  See https://bugs.ruby-lang.org/issues/10181

You may consider spawning off workers, maintaining a privileged master process,
and using IPC to communicate with them.

## Todo

Wrap Casper to provide DNS services, additional rights controls, etc.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake test` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Freaky/ruby-capsicum.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

