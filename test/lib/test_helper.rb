require 'bundler/setup'
require 'minitest/autorun'
require 'eol'

begin
  if RUBY_VERSION >= '2.0'
    require 'byebug'
  elsif RUBY_VERSION >= '1.9'
    require 'debugger'
  else
    require 'ruby-debug'
  end
rescue LoadError
end

class EOL::Test < Minitest::Spec
  class << self
    alias_method :test, :it
  end
end
