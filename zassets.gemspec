$:.unshift File.expand_path('../lib', __FILE__)
require 'zassets/version'

Gem::Specification.new do |s|
  s.name        = 'zassets'
  s.version     = ZAssets::VERSION
  s.summary     = "zassets-#{ZAssets::VERSION}"
  s.description = <<-eoh.gsub(/^ +/, '')
    Standalone asset pipeline based on sprockets.
  eoh
  s.homepage    = 'https://rubygems.org/gems/zassets'

  s.author      = 'Thibault Jouan'
  s.email       = 'tj@a13.fr'

  s.files       = `git ls-files`.split "\n"
  s.executables = s.files.grep(/\Abin\//).map { |f| File.basename(f) }

  s.add_dependency 'sprockets',         '2.8.1'

  s.add_dependency 'puma',              '~> 1.6'

  s.add_dependency 'therubyracer',      '~> 0.11'
  s.add_dependency 'libv8',             '~> 3.3'
  s.add_dependency 'coffee-script',     '2.2.0'

  s.add_development_dependency 'rspec', '~> 2.11'
end
