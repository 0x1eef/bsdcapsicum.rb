# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bsd/capsicum/version'

Gem::Specification.new do |spec|
  spec.name          = "bsdcapsicum.rb"
  spec.version       = BSD::Capsicum::VERSION
  spec.authors       = ["Thomas Hurst", "0x1eef"]
  spec.email         = ["0x1eef@protonmail.com"]

  spec.summary       = "Ruby bindings for FreeBSD's capsicum(4)"
  spec.homepage      = "https://github.com/0x1eef/bsdcapsicum.rb"
  spec.licenses      = ["0BSD", "MIT"]
  spec.files         = Dir["lib/*.rb", "lib/**/*.rb", "README.md", "LICENSE", "LICENSE.ruby-capsicum", "*.gemspec"]
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "fiddle", "~> 1.1"
  spec.add_development_dependency "bundler", "~> 2.5"
  spec.add_development_dependency "rake", "~> 13.2"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "standard", "~> 1.38"
  spec.add_development_dependency "test-cmd.rb", "~> 0.12"
  spec.add_development_dependency "xchan.rb", "~> 0.17"
end
