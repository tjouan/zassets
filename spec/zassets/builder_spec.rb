require 'spec_helper'

module ZAssets
  describe Builder do
    let(:config)      { Config.new }
    subject(:builder) { Builder.new(config) }

    describe '#build' do
      it 'compiles the manifest' do
        builder.manifest = double('manifest')
        expect(builder.manifest).to receive :compile
        builder.build
      end
    end

    describe '#manifest' do
      it 'builds a sprockets manifest' do
        expect(Sprockets::Manifest).to receive(:new).with(
          builder.environment,
          builder.manifest_path
        )
        builder.manifest
      end

      it 'returns the sprockets manifest' do
        manifest = double('manifest')
        allow(Sprockets::Manifest).to receive(:new) { manifest }
        expect(builder.manifest).to be manifest
      end
    end

    describe '#manifest_path' do
      it 'returns the manifest file path' do
        expected_path = File.join(config[:build_path], 'manifest.json')
        expect(builder.manifest_path).to eq expected_path
      end
    end

    describe '#environment' do
      it 'builds a sprockets env' do
        expect(SprocketsEnv).to receive(:new).with(config)
        builder.environment
      end

      it 'returns the sprockets env' do
        environment = double('environment')
        allow(SprocketsEnv).to receive(:new) { environment }
        expect(builder.environment).to be environment
      end
    end
  end
end
