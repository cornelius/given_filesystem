require_relative "lib/version.rb"

Gem::Specification.new do |s|
  s.name        = 'given_filesystem'
  s.version     = VERSION
  s.license     = 'MIT'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Cornelius Schumacher']
  s.email       = ['schumacher@kde.org']
  s.homepage    = 'https://github.com/cornelius/given_filesystem'
  s.summary     = 'A library for setting up files as test data'
  s.description = 'GivenFilesystem is a set of helpers for testing code which operates on file systems.'
  s.required_rubygems_version = '>= 1.3.6'
  s.rubyforge_project         = 'given_filesystem'

  s.add_development_dependency 'rspec', '~> 3.0'
  s.files        = `git ls-files`.split("\n")
  s.require_path = 'lib'
end
