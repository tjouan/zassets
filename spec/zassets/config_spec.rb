require 'spec_helper'

module ZAssets
  describe Config do
    include FixturesHelpers

    let(:config_file) { fixture_path_for 'config/zassets.yaml' }
    subject(:config)  { Config.new }

    describe '#initialize' do
      it 'assigns #default_options to @options' do
        expect(config.instance_eval { @options }).to eq config.default_options
      end

      it 'registers plugins' do
        expect_any_instance_of(Config).to receive :register_plugins!
        Config.new
      end

      context 'with a non-empty option hash' do
        it 'merges the option hash' do
          config = Config.new(verbose: true)
          expect(config[:verbose]).to be true
        end
      end

      context 'with config_file option' do
        subject(:config) { Config.new(config_file: config_file) }

        it 'merges the config file options in @options' do
          expect(config[:file_option]).to eq :file_value
        end

        it 'merges the config file options before argument options' do
          config = Config.new(file_option: :argument_value)
          expect(config[:file_option]).to eq :argument_value
        end
      end
    end

    describe '#default_options' do
      it 'sets verbose to false' do
        expect(config.default_options[:verbose]).to be false
      end

      it 'sets host to ::1' do
        expect(config.default_options[:host]).to eq '::1'
      end

      it 'sets port to 9292' do
        expect(config.default_options[:port]).to eq 9292
      end

      it 'sets server to puma' do
        expect(config.default_options[:server]).to eq :puma
      end

      it 'sets base_url to /assets' do
        expect(config.default_options[:base_url]).to eq '/assets'
      end

      it 'sets paths to app directory' do
        expect(config.default_options[:paths]).to eq ['app']
      end

      it 'sets public_path to public directory' do
        expect(config.default_options[:public_path]).to eq 'public'
      end

      it 'sets build_path to public/assets directory' do
        expect(config.default_options[:build_path]).to eq 'public/assets'
      end

      it 'sets build empty' do
        expect(config.default_options[:build]).to eq []
      end
    end

    describe '#load_options' do
      context 'when path is given as argument' do
        it 'loads symbolized options from YAML file' do
          expect(config.load_options(config_file)).to eq({
            file_option: :file_value
          })
        end
      end

      context 'without argument' do
        it 'loads the default config file path' do
          expect { config.load_options }
            .to raise_error /.*no such.+config\/zassets.yaml/i
        end
      end
    end

    describe '#default_config_file?' do
      context 'when file does not exist' do
        it 'returns false' do
          expect(config.default_config_file?).to be false
        end
      end

      context 'when file exists' do
        it 'returns true' do
          within_fixture_path do
            expect(config.default_config_file?).to be true
          end
        end
      end
    end

    describe '#register_plugins!' do
      subject(:config) { Config.new(plugins: ['dummy']) }

      it 'loads plugins' do
        config
        expect(Plugins::Dummy).to be
      end

      it 'registers them with current config' do
        expect(config[:dummy_plugin]).to eq :registered
      end
    end

    describe '#[]' do
      it 'returns an @options value from its key' do
        config.instance_eval { @options[:foo] = :bar }
        expect(config[:foo]).to eq :bar
      end
    end

    describe '#[]=' do
      it 'stores a value under given key' do
        config[:foo] = :bar
        expect(config[:foo]).to eq :bar
      end
    end
  end
end
