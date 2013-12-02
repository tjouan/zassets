lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH << lib unless $LOAD_PATH.include? lib
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

  s.files       = `git ls-files`.split $/
  s.test_files  = s.files.grep /\Aspec\//
  s.executables = s.files.grep(/\Abin\//) { |f| File.basename(f) }

  s.add_dependency 'sprockets',     '~> 2.10.0'
  s.add_dependency 'puma',          '~> 2.6.0'
  s.add_dependency 'sass',          '~> 3.2.10'
  s.add_dependency 'execjs',        '~> 2.0.2'
  s.add_dependency 'coffee-script', '~> 2.2.0'

  s.add_development_dependency 'rspec',     '~> 3.0.0.beta1'
  s.add_development_dependency 'cucumber',  '~> 1.3.10'
  s.add_development_dependency 'aruba',     '~> 0.5.3'
  s.add_development_dependency 'httparty',  '~> 0.12.0'
  s.add_development_dependency 'rake'
end
