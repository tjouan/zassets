require 'spec_helper'

module ZAssets
  describe Builder do
    let(:config)      { Config.new }
    subject(:builder) { Builder.new(config) }

    describe '#build' do
      it 'compiles the manifest' do
        builder.manifest = double('manifest')
        builder.manifest.should_receive :compile
        builder.build
      end
    end

    describe '#manifest' do
      it 'builds a sprockets manifest' do
        Sprockets::Manifest.should_receive(:new).with(
          builder.environment,
          builder.manifest_path
        )
        builder.manifest
      end

      it 'returns the sprockets manifest' do
        manifest = double('manifest')
        Sprockets::Manifest.stub(:new) { manifest }
        builder.manifest.should == manifest
      end
    end

    describe '#manifest_path' do
      it 'returns the manifest file path' do
        builder.manifest_path.should == File.join(
          config[:build_path],
          'manifest.json'
        )
      end
    end

    describe '#environment' do
      it 'builds a sprockets env' do
        SprocketsEnv.should_receive(:new).with(config)
        builder.environment
      end

      it 'returns the sprockets env' do
        environment = double('environment')
        SprocketsEnv.stub(:new) { environment }
        builder.environment.should == environment
      end
    end
  end
end
