Gem::Specification.new do |s|
  s.name      = 'eol'
  s.summary   = "EOL sniffs line ending style and binary vs. text using Git's heuristics"
  s.license   = 'MIT'

  s.version   = '0.1.0'

  s.author    = 'Jeremy Daer'
  s.email     = 'jeremydaer@gmail.com'
  s.homepage  = 'https://github.com/jeremy/eol'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'minitest'

  s.files = Dir.glob('lib/**')
end
