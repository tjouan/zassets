require 'spec_helper'

module ZAssets
  describe Config do
    include FixturesHelpers

    subject(:config)

    let(:config_file) { fixture_path_for 'config/zassets.yaml' }

    describe '#initialize' do
      context 'with an empty option hash' do
        it 'assigns #default_options to @options' do
          config.instance_eval { @options }.should == config.default_options
        end
      end

      context 'with a non-empty option hash' do
        subject(:config) { Config.new(some_option: :some_value)}

        it 'merges the option hash' do
          config[:some_option].should == :some_value
        end

        it 'merges the option hash after default options' do
          Config.any_instance.stub(:default_options) {
            { some_option: :default_value }
          }
          config = Config.new(some_option: :argument_value)
          config[:some_option].should == :argument_value
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
        config.default_options[:verbose].should be_false
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

      it 'sets paths empty' do
        config.default_options[:paths].should == []
      end

      it 'sets public_path to public directory' do
        config.default_options[:public_path].should == 'public'
      end

      it 'sets compile_path to public/assets directory' do
        config.default_options[:compile_path].should == 'public/assets'
      end

      it 'sets compile empty' do
        config.default_options[:compile].should == []
      end
    end

    describe '#load_options' do
      it 'loads symbolized options from YAML file' do
        config.load_options(config_file).should == {
          file_option: :file_value
        }
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
