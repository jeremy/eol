source 'https://rubygems.org'

gemspec

gem 'rake', '< 11.0' if RUBY_VERSION < '1.9.3'

if RUBY_VERSION >= '2.0'
  gem 'byebug', :platforms => :mri
elsif RUBY_VERSION >= '1.9'
  gem 'debugger', :platforms => :mri
else
  gem 'ruby-debug', :platforms => :mri
end
