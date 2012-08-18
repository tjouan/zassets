require 'optparse'

module ZAssets
  class CLI
    def initialize(args)
      @options = args_parse! args
    end

    def args_parse!(args)
      options = {}
      parser = OptionParser.new do |o|
        o.banner = "Usage: #{File.basename $0} [options] [compile|serve]"

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
          puts o
          exit
        end

        o.on '-V', '--version', 'Show version' do
          puts VERSION
          exit
        end
      end

      begin
        parser.parse! args
      rescue OptionParser::InvalidOption => e
        warn e.message
        puts parser
        exit 64
      end

      if args.last && args.last == 'serve'
        options[:command] = :serve
      elsif ! args.last
        options[:command] = :compile
      else
        puts parser
        exit 64
      end

      options
    end

    def config
      @config ||= Config.new @options
    end

    def run
      case config[:command]
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
