require 'yaml'

module ZAssets
  class Config
    DEFAULT_OPTIONS = {
      verbose:      false,
      host:         '::1',
      port:         9292,
      server:       :puma,
      plugins:      [],
      engines:      {},
      base_url:     '/assets',
      paths:        [],
      public_path:  'public',
      compile_path: 'public/assets',
      compile:      []
    }

    def initialize(options = {})
      o = default_options
      o.merge! load_options(options[:config_file]) if options[:config_file]
      o.merge! options
      @options = o
      register_plugins!
    end

    def default_options
      DEFAULT_OPTIONS.dup
    end

    def load_options(filepath)
      return {} unless options = YAML.load_file(filepath)
      options.keys.each do |key|
        options[(key.to_sym rescue key) || key] = options.delete(key)
      end
      options
    end

    def register_plugins!
      return unless load_plugins!

      ::ZAssets::Plugins.constants.each do |plugin_module_name|
        plugin_module = ::ZAssets::Plugins.const_get(plugin_module_name)
        plugin_module::Registrant.new(self).register
      end
    end

    def [](key)
      @options[key]
    end

    def []=(key, value)
      @options[key] = value
    end


    private

    def load_plugins!
      @options[:plugins].each do |plugin|
        require "zassets-plugins-#{plugin}"
      end

      return ::ZAssets.const_defined? :Plugins
    end
  end
end
