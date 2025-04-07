require "bundler/setup"
require "bundler/gem_tasks"
require "rake/testtask"
require 'rake/extensiontask'

Rake::ExtensionTask.new('bsdcapsicum.rb')
task default: %w[clobber compile test]

task :test do
  sh "bin/test-runner"
end
task :default => :test
