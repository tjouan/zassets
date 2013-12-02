require 'spec_helper'

module ZAssets
  describe CLI do
    let(:args)    { ['serve'] }
    subject(:cli) { CLI.new(args) }

    describe '#initialize' do
      context 'action arguments parsing' do
        it 'parses the action' do
          expect(cli.action).to eq :serve
        end

        context 'when action is not provided' do
          let(:args) { [] }

          it 'defaults to build' do
            expect(cli.action).to eq :build
          end
        end
      end

      context 'option arguments parsing' do
        def with_option(option, value = nil)
          if value
            CLI.new [option, value, *args]
          else
            CLI.new [option, *args]
          end
        end

        it 'parses the -v option' do
          expect(with_option('-v').options[:verbose]).to be true
        end

        it 'parses the -c option' do
          expect(with_option('-c', 'config').options[:config_file])
            .to eq 'config'
        end

        it 'parses the -o option' do
          expect(with_option('-o', '::0').options[:host]).to eq '::0'
        end

        it 'parses the -p option' do
          expect(with_option('-p', '9393').options[:port]).to eq '9393'
        end

        it 'parses the -s option' do
          expect(with_option('-s', 'thin').options[:server]).to eq 'thin'
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
            expect(output.string).to match /\AUsage: /
          end

          it 'exits' do
            expect { cli }.to raise_error SystemExit
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
            expect(output.string.chomp).to eq VERSION
          end

          it 'exits' do
            expect { cli }.to raise_error SystemExit
          end
        end
      end
    end

    describe '#action' do
      it 'return the current action' do
        expect(cli.action).to eq args.last.to_sym
      end
    end

    describe '#config' do
      it 'builds a config' do
        expect(Config).to receive(:new).with(cli.options)
        cli.config
      end

      it 'returns the config' do
        config = double('config')
        allow(Config).to receive(:new) { config }
        expect(cli.config).to be config
      end
    end

    describe '#run' do
      context 'serve action' do
        it 'runs the server' do
          server = double('server')
          allow(cli).to receive(:server) { server }
          expect(server).to receive :run
          cli.run
        end
      end

      context 'build action' do
        let(:args) { ['build'] }

        it 'runs the builder' do
          builder = double('builder')
          allow(cli).to receive(:builder) { builder }
          expect(builder).to receive :build
          cli.run
        end
      end
    end

    describe '#builder' do
      it 'builds a builder' do
        expect(Builder).to receive(:new).with(cli.config)
        cli.builder
      end

      it 'returns the builder' do
        builder = double('builder')
        allow(Builder).to receive(:new) { builder }
        expect(cli.builder).to be builder
      end
    end

    describe '#server' do
      it 'builds a server' do
        expect(Server).to receive(:new).with(cli.config)
        cli.server
      end

      it 'returns the server' do
        server = double('server')
        allow(Server).to receive(:new) { server }
        expect(cli.server).to be server
      end
    end
  end
end
