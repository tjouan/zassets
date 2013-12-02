require 'spec_helper'

module ZAssets
  describe CLI do
    let(:args)    { ['serve'] }
    subject(:cli) { CLI.new(args) }

    describe '#initialize' do
      context 'action arguments parsing' do
        it 'parses the action' do
          cli.action.should == :serve
        end

        context 'when action is not provided' do
          let(:args) { [] }

          it 'defaults to build' do
            cli.action.should == :build
          end
        end
      end

      context 'option arguments parsing ' do
        def with_option(option, value = nil)
          if value
            CLI.new [option, value, *args]
          else
            CLI.new [option, *args]
          end
        end

        it 'parses the -v option' do
          with_option('-v').options[:verbose].should be true
        end

        it 'parses the -c option' do
          with_option('-c', 'config').options[:config_file].should == 'config'
        end

        it 'parses the -o option' do
          with_option('-o', '::0').options[:host].should == '::0'
        end

        it 'parses the -p option' do
          with_option('-p', '9393').options[:port].should == '9393'
        end

        it 'parses the -s option' do
          with_option('-s', 'thin').options[:server].should == 'thin'
        end

        context '-h option' do
          let(:args)    { ['-h'] }
          let(:output)  { StringIO.new }
          subject(:cli) { CLI.new(args, output) }

          it 'prints the usage help' do
            begin
              cli
            rescue SystemExit
            end
            output.string.should =~ /\AUsage: /
          end

          it 'exits' do
            lambda { cli }.should raise_error SystemExit
          end
        end

        context '-V option' do
          let(:args)    { ['-V'] }
          let(:output)  { StringIO.new }
          subject(:cli) { CLI.new(args, output) }

          it 'prints the version' do
            begin
              cli
            rescue SystemExit
            end
            output.string.chomp.should == VERSION
          end

          it 'exits' do
            lambda { cli }.should raise_error SystemExit
          end
        end
      end
    end

    describe '#action' do
      it 'return the current action' do
        cli.action.should == args.last.to_sym
      end
    end

    describe '#config' do
      it 'builds a config' do
        Config.should_receive(:new).with(cli.options)
        cli.config
      end

      it 'returns the config' do
        config = double('config')
        Config.stub(:new) { config }
        cli.config.should == config
      end
    end

    describe '#run' do
      context 'serve action' do
        it 'runs the server' do
          server = double('server')
          cli.stub(:server) { server }
          server.should_receive :run
          cli.run
        end
      end

      context 'build action' do
        let(:args) { ['build'] }

        it 'runs the builder' do
          builder = double('builder')
          cli.stub(:builder) { builder }
          builder.should_receive :build
          cli.run
        end
      end
    end

    describe '#builder' do
      it 'builds a builder' do
        Builder.should_receive(:new).with(cli.config)
        cli.builder
      end

      it 'returns the builder' do
        builder = double('builder')
        Builder.stub(:new) { builder }
        cli.builder.should == builder
      end
    end

    describe '#server' do
      it 'builds a server' do
        Server.should_receive(:new).with(cli.config)
        cli.server
      end

      it 'returns the server' do
        server = double('server')
        Server.stub(:new) { server }
        cli.server.should == server
      end
    end
  end
end
