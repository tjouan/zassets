require 'unicorn'
require 'rack/handler'

module Rack
  module Handler
    class Unicorn
      UNICORN_CONFIG_PATH = 'config/unicorn.rb'.freeze

      class << self
        def run app, **options
          unicorn_options = {
            listeners:        [options[:Host], options[:Port]].join(':'),
            worker_processes: 2
          }

          if ::File.exist?(UNICORN_CONFIG_PATH)
            unicorn_options[:config_file] = UNICORN_CONFIG_PATH
          end

          if unicorn_options[:config_file]
            if ::File.read(unicorn_options[:config_file]) =~ /^(\s+)listen\s/
              unicorn_options.delete :listeners
            end
          end

          ::Unicorn::HttpServer.new(app, unicorn_options).start.join
        end
      end
    end

    register 'unicorn', 'Rack::Handler::Unicorn'
  end
end
