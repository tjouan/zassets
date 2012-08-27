$:.unshift File.expand_path('../lib', __FILE__)
require 'zassets/version'

Gem::Specification.new do |s|
  s.name        = 'zassets'
  s.version     = ZAssets::VERSION
  s.summary     = "zassets-#{ZAssets::VERSION}"
  s.description = <<-eoh.gsub(/^ +/, '')
    Standalone asset manager based on sprockets and sprockets-helpers.
  eoh
  s.homepage    = 'https://rubygems.org/gems/zassets'

  s.author      = 'Thibault Jouan'
  s.email       = 'tj@a13.fr'

  s.files       = `git ls-files`.split "\n"
  s.executables = s.files.grep(/\Abin\//).map { |f| File.basename(f) }

  s.add_dependency 'sprockets',         '~> 2.4'
  s.add_dependency 'sprockets-helpers', '~> 0.4'

  s.add_dependency 'puma',              '~> 1.6'

  s.add_dependency 'therubyracer',      '~> 0.11.0beta8'
  s.add_dependency 'libv8',             '~> 3.3.10.4'
  s.add_dependency 'coffee-script',     '~> 2.2'
  s.add_dependency 'less',              '~> 2.2'
end
