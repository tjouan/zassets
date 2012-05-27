require 'sprockets'
require 'sprockets-helpers'

module ZAssets
  class SprocketsEnv < Sprockets::Environment
    def initialize(config)
      super '.'

      self.logger.level = Logger::DEBUG if config[:verbose]

      config[:paths].each { |p| append_path p }

      Sprockets::Helpers.configure do |c|
        c.environment = self
        c.prefix      = config[:base_url]
        c.digest      = true
        c.public_path = config[:public_path]
      end
    end
  end
end
