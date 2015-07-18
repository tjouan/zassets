require 'rack'

module ZAssets
  class Server
    HANDLERS = %w[puma unicorn thin webrick].freeze

    def initialize config
      @config = config
    end

    def run
      handler.run app, options do |server|
        %i[INT TERM].each do |sig|
          trap(sig) { server.respond_to?(:stop!) ? server.stop! : server.stop }
        end
      end
    end

    def handler
      Rack::Handler.get(@config[:server]) || Rack::Handler.pick(HANDLERS)
    end

    def options
      @options ||= {
        environment:  :development,
        Host:         @config[:host],
        Port:         @config[:port]
      }
    end

    def app
      config = @config

      @app ||= Rack::Builder.app do
        use Rack::CommonLogger
        use Rack::ShowExceptions
        use Rack::Lint

        map config[:base_url] do
          run SprocketsEnv.new(config)
        end

        map '/' do
          static_files = Rack::File.new(config[:public_path])

          if config[:public_file]
            run Rack::Cascade.new([
              static_files,
              MemoryFile.new(File.new(File.join(
                config[:public_path],
                config[:public_file]
              )))
            ])
          else
            run static_files
          end
        end
      end
    end
  end
end
