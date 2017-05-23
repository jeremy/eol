require 'rake'
require 'rake/testtask'

task :default => :test

Rake::TestTask.new do |t|
  t.libs << 'test/lib'
  t.pattern = 'test/*_test.rb'

  t.warning = true
  t.verbose = false
end
