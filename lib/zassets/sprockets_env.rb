require 'sprockets'

module ZAssets
  class SprocketsEnv < Sprockets::Environment
    def initialize(config)
      super '.'

      logger.level = Logger::DEBUG if config[:verbose]

      config[:engines].each { |ext, engine| register_engine ext, engine }

      config[:paths].each { |p| append_path p }
    end
  end
end
