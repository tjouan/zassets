require 'spec_helper'

module ZAssets
  describe Compiler do
    let(:config)        { Config.new }
    subject(:compiler)  { Compiler.new(config) }

    describe '#compile' do
      it 'compiles the manifest' do
        compiler.manifest = double('manifest')
        compiler.manifest.should_receive :compile
        compiler.compile
      end
    end

    describe '#manifest' do
      it 'builds a sprockets manifest' do
        Sprockets::Manifest.should_receive(:new).with(
          compiler.environment,
          config[:compile_path]
        )
        compiler.manifest
      end

      it 'returns the sprockets manifest'do
        manifest = double('manifest')
        Sprockets::Manifest.stub(:new) { manifest }
        compiler.manifest.should == manifest
      end
    end

    describe '#environment' do
      it 'builds a sprockets env' do
        SprocketsEnv.should_receive(:new).with(config)
        compiler.environment
      end

      it 'returns the sprockets env' do
        environment = double('environment')
        SprocketsEnv.stub(:new) { environment }
        compiler.environment.should == environment
      end
    end
  end
end
