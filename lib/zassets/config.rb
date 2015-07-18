require 'yaml'

module ZAssets
  class Config
    DEFAULT_CONFIG_PATH = 'config/zassets.yaml'.freeze

    DEFAULT_OPTIONS = {
      verbose:      false,
      host:         '::1',
      port:         9292,
      server:       :puma,
      plugins:      [],
      engines:      {},
      base_url:     '/assets',
      paths:        %w[app],
      public_path:  'public',
      build_path:   'public/assets',
      build:        []
    }.freeze

    def initialize **options
      o = default_options
      o.merge! load_options if default_config_file?
      o.merge! load_options(options[:config_file]) if options[:config_file]
      o.merge! options
      @options = o
      register_plugins!
    end

    def default_options
      DEFAULT_OPTIONS.dup
    end

    def load_options filepath = DEFAULT_CONFIG_PATH
      return {} unless options = YAML.load_file(filepath)
      symbolize_keys options
    end

    def default_config_file?
      File.exist?(DEFAULT_CONFIG_PATH)
    end

    def register_plugins!
      return unless load_plugins!
      ::ZAssets::Plugins.constants.each do |plugin_module_name|
        plugin_module = ::ZAssets::Plugins.const_get(plugin_module_name)
        plugin_module::Registrant.new(self).register
      end
    end

    def [] key
      @options[key]
    end

    def []= key, value
      @options[key] = value
    end

  private

    def symbolize_keys hash
      case hash
      when Hash
        Hash[hash.map do |k, v|
          [k.respond_to?(:to_sym) ? k.to_sym : k, symbolize_keys(v)]
        end]
      when Enumerable
        hash.map { |v| symbolize_keys v }
      else
        hash
      end
    end

    def load_plugins!
      @options[:plugins].each do |plugin|
        require 'zassets-plugins-%s' % case plugin
          when Hash           then plugin[:name]
          when Symbol, String then plugin
        end
      end
      ::ZAssets.const_defined? :Plugins
    end
  end
end
