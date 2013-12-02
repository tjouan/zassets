require 'spec_helper'

module ZAssets
  describe Config do
    include FixturesHelpers

    let(:config_file) { fixture_path_for 'config/zassets.yaml' }
    subject(:config)  { Config.new }

    describe '#initialize' do
      it 'assigns #default_options to @options' do
        config.instance_eval { @options }.should == config.default_options
      end

      it 'registers plugins' do
        Config.any_instance.should_receive :register_plugins!
        Config.new
      end

      context 'with a non-empty option hash' do
        it 'merges the option hash' do
          config = Config.new(verbose: true)
          config[:verbose].should == true
        end
      end

      context 'with config_file option' do
        subject(:config) { Config.new(config_file: config_file) }

        it 'merges the config file options in @options' do
          config[:file_option].should == :file_value
        end

        it 'merges the config file options before argument options' do
          config = Config.new(file_option: :argument_value)
          config[:file_option].should == :argument_value
        end
      end
    end

    describe '#default_options' do
      it 'sets verbose to false' do
        config.default_options[:verbose].should be false
      end

      it 'sets host to ::1' do
        config.default_options[:host].should == '::1'
      end

      it 'sets port to 9292' do
        config.default_options[:port].should == 9292
      end

      it 'sets server to puma' do
        config.default_options[:server].should == :puma
      end

      it 'sets base_url to /assets' do
        config.default_options[:base_url].should == '/assets'
      end

      it 'sets paths to app directory' do
        config.default_options[:paths].should == ['app']
      end

      it 'sets public_path to public directory' do
        config.default_options[:public_path].should == 'public'
      end

      it 'sets build_path to public/assets directory' do
        config.default_options[:build_path].should == 'public/assets'
      end

      it 'sets build empty' do
        config.default_options[:build].should == []
      end
    end

    describe '#load_options' do
      context 'when path is given as argument' do
        it 'loads symbolized options from YAML file' do
          config.load_options(config_file).should == {
            file_option: :file_value
          }
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
          config.default_config_file?.should be false
        end
      end

      context 'when file exists' do
        it 'returns true' do
          within_fixture_path do
            config.default_config_file?.should be true
          end
        end
      end
    end

    describe '#register_plugins!' do
      subject(:config) { Config.new(plugins: ['dummy']) }

      it 'loads plugins' do
        config
        Plugins::Dummy.should be
      end

      it 'registers them with current config' do
        config[:dummy_plugin].should == :registered
        config = Config.new(plugins: ['dummy'])
      end
    end

    describe '#[]' do
      it 'returns an @options value from its key' do
        config.instance_eval { @options[:foo] = :bar }
        config[:foo].should == :bar
      end

      it 'stores a value under given key' do
        config[:foo] = :bar
        config[:foo].should == :bar
      end
    end
  end
end
