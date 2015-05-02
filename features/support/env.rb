require 'aruba/api'
require 'aruba/cucumber/hooks'
require 'httparty'

World(Aruba::Api)

DEFAULT_CONFIG_PATH = 'config/zassets.yaml'
