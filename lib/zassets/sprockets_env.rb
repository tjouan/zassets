require 'sprockets'

module ZAssets
  class SprocketsEnv < Sprockets::Environment
    def initialize(config)
      super '.'

      self.logger.level = Logger::DEBUG if config[:verbose]

      config[:paths].each { |p| append_path p }
    end
  end
end
