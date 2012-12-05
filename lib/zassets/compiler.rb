require 'sprockets'

module ZAssets
  class Compiler
    MANIFEST_FILENAME = 'manifest.json'

    attr_writer :manifest

    def initialize(config)
      @config = config
    end

    def compile
      manifest.compile(@config[:compile])
    end

    def manifest
      @manifest ||= Sprockets::Manifest.new(environment, manifest_path)
    end

    def manifest_path
      [@config[:compile_path], MANIFEST_FILENAME].join '/'
    end

    def environment
      @environment ||= SprocketsEnv.new(@config)
    end
  end
end
