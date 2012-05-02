require 'test/unit'
require 'bundler'

Bundler.setup(:default, :development)

$:.push File.expand_path("../lib", File.dirname(__FILE__))
require File.expand_path("../lib/undestroyable", File.dirname(__FILE__))

require 'ruby-debug'