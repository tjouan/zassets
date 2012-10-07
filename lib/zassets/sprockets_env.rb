require 'sprockets'

module Sprockets
  autoload :LessTemplate, 'sprockets/less_template'
end

module ZAssets
  class SprocketsEnv < Sprockets::Environment
    def initialize(config)
      super '.'

      self.logger.level = Logger::DEBUG if config[:verbose]

      self.register_engine '.less', ::Sprockets::LessTemplate

      config[:paths].each { |p| append_path p }

      require 'handlebars_assets'
      append_path HandlebarsAssets.path
      self.register_engine '.hbs', ::HandlebarsAssets::TiltHandlebars
    end
  end
end
