require 'optparse'

module ZAssets
  class CLI
    attr_reader :options

    def initialize(args, stdout = $stdout)
      @stdout = stdout
      @options = args_parse! args
    end

    def args_parse!(args)
      options = {}
      parser = OptionParser.new do |o|
        o.banner = "Usage: #{File.basename $0} [options] compile|serve"

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

      if args.last && %w(compile serve).include?(args.last)
        options[:action] = args.last.to_sym
      else
        @stdout.puts parser
        exit 64
      end

      options
    end

    def config
      @config ||= Config.new @options
    end

    def run
      case config[:action]
      when :serve
        server.run
      when :compile
        compiler.compile
      end
    end

    def compiler
      @compiler ||= Compiler.new config
    end

    def server
      @server ||= Server.new config
    end
  end
end
