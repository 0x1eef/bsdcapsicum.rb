# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bsd/capsicum/version'

Gem::Specification.new do |spec|
  spec.name          = "bsdcapsicum.rb"
  spec.version       = BSD::Capsicum::VERSION
  spec.authors       = ["Thomas Hurst"]
  spec.email         = ["tom@hur.st"]

  spec.summary       = %q{Ruby bindings for FreeBSD's capsicum(4)}
  spec.homepage      = "https://github.com/Freaky/ruby-capsicum"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.5"
  spec.add_development_dependency "rake", "~> 13.2"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "standard", "~> 1.38"
  spec.add_development_dependency "test-cmd.rb", "~> 0.12"
  spec.add_development_dependency "xchan.rb", "~> 0.17"
end