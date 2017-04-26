Gem::Specification.new do |s|
  s.name        = 'esms_tools'
  s.version     = '0.1.2'
  s.date        = '2017-04-24'
  s.summary     = "ESMS  (text football manager game) extra tools"
  s.description = "A gem to provide extra tools to the ESMS (Electronic Soccer Management Simulator)"
  s.authors     = ["L. Jacob Mariscal Fernández"]
  s.email       = 'l.jacob.m.f@gmail.com'
  s.files       = ["lib/esms_tools.rb"]
  s.homepage    = 'http://rubygems.org/gems/esms_tools'
  s.licenses    = ['LGPL-3.0']
  s.post_install_message = "Thanks for installing esms_tools gem"
  s.executables << 'esms_tools'
  s.add_development_dependency 'minitest', '~> 5.3'
end
