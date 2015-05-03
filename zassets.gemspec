require File.expand_path('../lib/zassets/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'zassets'
  s.version     = ZAssets::VERSION.dup
  s.summary     = "zassets-#{ZAssets::VERSION}"
  s.description = 'Assets server and builder'
  s.license     = 'BSD-3-Clause'
  s.homepage    = 'https://rubygems.org/gems/zassets'

  s.author      = 'Thibault Jouan'
  s.email       = 'tj@a13.fr'

  s.files       = `git ls-files lib`.split $/
  s.executable  = 'zassets'
  s.extra_rdoc_files = %w[README.md]

  s.add_dependency 'coffee-script', '~> 2.2'
  s.add_dependency 'execjs',        '~> 2.0'
  s.add_dependency 'puma',          '~> 2.6'
  s.add_dependency 'sass',          '~> 3.2'
  s.add_dependency 'sprockets',     '~> 2.10'

  s.add_development_dependency 'aruba',     '~> 0.5'
  s.add_development_dependency 'cucumber',  '~> 2.0'
  s.add_development_dependency 'httparty',  '~> 0.12'
  s.add_development_dependency 'rake',      '~> 10.4'
  s.add_development_dependency 'rspec',     '~> 3.2'
end
