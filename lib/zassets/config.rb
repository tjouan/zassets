require 'yaml'

module ZAssets
  class Config
    def initialize(options)
      o = defaults_options
      o.merge! load_options(options[:config_file]) if options[:config_file]
      o.merge! options
      @options = o
    end

    def defaults_options
      {
        :verbose      => false,
        :host         => '::1',
        :port         => 9292,
        :base_url     => '/assets',
        :paths        => [],
        :public_path  => 'public/assets',
        :compile      => []
      }
    end

    def load_options(filepath)
      return {} unless options = YAML.load_file(filepath)
      options.keys.each do |key|
        options[(key.to_sym rescue key) || key] = options.delete(key)
      end
      options
    end

    def [](key)
      @options[key]
    end
  end
end
