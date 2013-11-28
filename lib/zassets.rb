require 'zassets/version'
require 'coffee_script'

module ZAssets
  autoload :CLI,          'zassets/cli'
  autoload :Builder,      'zassets/builder'
  autoload :Config,       'zassets/config'
  autoload :MemoryFile,   'zassets/memory_file'
  autoload :Server,       'zassets/server'
  autoload :SprocketsEnv, 'zassets/sprockets_env'
end
