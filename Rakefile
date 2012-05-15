# encoding: utf-8

require 'rubygems'
require 'bundler'
require 'rake'
require 'rake/testtask'
require 'jeweler'
require 'yard'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "undestroyable"
  gem.homepage = "http://github.com/kot-begemot/undestroyable"
  gem.license = "MIT"
  gem.summary = 'Undestroyable gem'
  gem.description = 'An aim or this gem is to provide an agile and comfortable way \
for Ruby developers to get rid of unnecessary data within their project databases.'
  gem.email = "emax@studentify.nl"
  gem.authors = ["E-Max"]
end
Jeweler::RubygemsDotOrgTasks.new

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/cases/**/*_test.rb']
  t.verbose = true
end

YARD::Rake::YardocTask.new

task :default => :test