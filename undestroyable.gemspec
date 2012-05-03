# -*- encoding: utf-8 -*-
$:.push File.expand_path("lib", File.dirname(__FILE__))
require File.expand_path("lib/undestroyable/version", File.dirname(__FILE__))

Gem::Specification.new do |s|
  s.name        = "undestroyable"
  s.version     = Undestroyable::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["E-Max"]
  s.email       = ["emax@studentify.nl"]
  s.homepage    = "http://github.com/kot-begemot/undestroyable"
  s.summary     = "Undestroyable gem"
  s.description = "An aim or this gem is to provide an agile and comfortable way \
for Ruby developers to get rid of unnecessary data within their project databases."

  s.required_rubygems_version = ">= 1.3.6"

  # lol - required for validation
  s.rubyforge_project         = "undestroyable"

  # If you need to check in files that aren't .rb files, add them here
  s.files        = Dir["{lib}/**/*.rb", "LICENSE", "*.md", "Rakefile"]
  s.require_path = 'lib'

  s.add_development_dependency("activesupport", ">= 3.0.0")
  s.add_development_dependency("activerecord", ">= 3.0.0")
  s.add_development_dependency('sqlite3')
  s.add_development_dependency("database_cleaner", "~> 0.7.2")
  #s.add_development_dependency('ruby-debug19')
end