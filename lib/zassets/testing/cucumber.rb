require 'aruba/api'
require 'aruba/cucumber/hooks'

require 'zassets/testing/cucumber/builder_steps'
require 'zassets/testing/cucumber/config_steps'
require 'zassets/testing/cucumber/filesystem_steps'
require 'zassets/testing/cucumber/manifest_steps'
require 'zassets/testing/cucumber/output_steps'
require 'zassets/testing/cucumber/run_steps'

World(Aruba::Api)

DEFAULT_CONFIG_PATH = 'config/zassets.yaml'
