source 'https://rubygems.org'

gemspec

group :development, :test do
  gem 'guard',        '~> 1.4'
  gem 'guard-rspec',  '~> 2.0'
  if RbConfig::CONFIG['target_os'] =~ /linux/i
    gem 'rb-inotify', '~> 0.8'
  end
end
