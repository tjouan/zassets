require 'optparse'

module ZAssets
  class CLI
    ACTIONS = %w(build serve)

    attr_reader :options, :action

    def initialize(args, stdout = $stdout)
      @stdout = stdout
      @action = :build
      args_parse! args
    end

    def config
      @config ||= Config.new @options
    end

    def run
      case @action
      when :serve
        server.run
      when :build
        builder.build
      end
    end

    def builder
      @builder ||= Builder.new config
    end

    def server
      @server ||= Server.new config
    end


    private

    def args_parse!(args)
      options = {}
      parser = OptionParser.new do |o|
        o.banner = "Usage: #{File.basename $0} [options] [build|serve]"

        o.on '-v', '--verbose', 'Enable verbose mode' do |v|
          options[:verbose] = v
        end

        o.on '-c', '--config FILE', 'Load default options from FILE' do |f|
          options[:config_file] = f
        end

        o.on '-o', '--host HOST', 'Listen on HOST (default: ::1)' do |h|
          options[:host] = h
        end

        o.on '-p', '--port PORT', 'Listen on PORT (default: 9292)' do |p|
          options[:port] = p
        end

        o.on '-s', '--server SERVER', 'Use SERVER as Rack handler' do |s|
          options[:server] = s
        end

        o.on '-h', '--help', 'Show this message' do
          @stdout.puts o
          exit
        end

        o.on '-V', '--version', 'Show version' do
          @stdout.puts VERSION
          exit
        end
      end

      begin
        parser.parse! args
      rescue OptionParser::InvalidOption => e
        warn e.message
        @stdout.puts parser
        exit 64
      end

      @options  = options
      @action   = args.last.to_sym if args.last && ACTIONS.include?(args.last)
    end
  end
end
