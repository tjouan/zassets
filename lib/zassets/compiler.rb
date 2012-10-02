require 'sprockets'

module ZAssets
  class Compiler
    attr_writer :manifest

    def initialize(config)
      @config = config
    end

    def compile
      manifest.compile(@config[:compile])
    end

    def manifest
      @manifest ||= Sprockets::Manifest.new(environment, @config[:compile_path])
    end

    def environment
      @environment ||= SprocketsEnv.new(@config)
    end
  end
end
