require 'sprockets'

module ZAssets
  class Compiler
    def initialize(config)
      @config = config
    end

    def compile
      if @config[:compile]
        manifest.compile(@config[:compile])
      else
        manifest.compile
      end
    end

    def manifest
      @manifest ||= Sprockets::Manifest.new(environment, @config[:public_path])
    end

    def environment
      @environment ||= SprocketsEnv.new(@config)
    end
  end
end
