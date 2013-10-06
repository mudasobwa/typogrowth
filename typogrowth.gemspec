$:.push File.expand_path("../lib", __FILE__)
require 'typogrowth/version'

Gem::Specification.new do |s|
  s.name = 'typogrowth'
  s.version = Typogrowth::VERSION
  s.platform = Gem::Platform::RUBY
  s.date = '2013-10-06'
  s.authors = ['Alexei Matyushkin']
  s.email = 'am@mudasobwa.ru'
  s.homepage = 'http://github.com/mudasobwa/typogrowth'
  s.summary = %Q{Simple library to produce typography texts}
  s.description = %Q{TODO: detailed description of your gem}
  s.extra_rdoc_files = [
    'LICENSE',
    'README.rdoc',
  ]

  s.required_rubygems_version = Gem::Requirement.new('>= 1.3.7')
  s.rubygems_version = '1.3.7'
  s.specification_version = 3

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'yard'
  s.add_development_dependency 'cucumber'
  s.add_development_dependency 'bueller'
end

