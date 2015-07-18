require 'sprockets'

module ZAssets
  class Builder
    MANIFEST_FILENAME = 'manifest.json'.freeze

    attr_writer :manifest

    def initialize config
      @config = config
    end

    def build
      manifest.compile @config[:build]
    end

    def manifest
      @manifest ||= Sprockets::Manifest.new(environment, manifest_path)
    end

    def manifest_path
      [@config[:build_path], MANIFEST_FILENAME].join '/'
    end

    def environment
      @environment ||= SprocketsEnv.new(@config)
    end
  end
end
