require 'rack'

module ZAssets
  class Server
    def initialize(config)
      @config = config
    end

    def run
      handler.run app, options do |server|
        [:INT, :TERM].each do |sig|
          trap(sig) { server.respond_to?(:stop!) ? server.stop! : server.stop }
        end
      end
    end

    def handler
      Rack::Handler.get(@config[:server]) || Rack::Handler.default
    end

    def options
      @options ||= {
        :environment  => :development,
        :Host         => @config[:host],
        :Port         => @config[:port]
      }
    end

    def app
      config = @config

      @app ||= Rack::Builder.new do
        use Rack::CommonLogger
        use Rack::ShowExceptions
        use Rack::Lint

        map config[:base_url] do
          run SprocketsEnv.new(config)
        end

        map '/' do
          run Rack::File.new 'docroot'
        end
      end
    end
  end
end
