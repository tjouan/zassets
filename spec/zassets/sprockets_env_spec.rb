require 'spec_helper'

module ZAssets
  describe SprocketsEnv do
    let(:config)  { Config.new }
    subject(:env) { SprocketsEnv.new(config) }

    describe 'working directory' do
      it 'initializes with current working directory' do
        expect(env.root).to eq Dir.pwd
      end
    end

    describe 'logger level' do
      context 'by default' do
        it 'defaults to fatal' do
          expect(env.logger.level).to eq Logger::FATAL
        end
      end

      context 'in verbose mode' do
        let(:config) { Config.new(verbose: true)}

        it 'is set to debug' do
          expect(env.logger.level).to eq Logger::DEBUG
        end
      end
    end

    describe 'search paths' do
      let(:paths)   { ['assets/scripts', 'assets/styles'] }
      let(:config)  { Config.new(paths: paths) }

      it 'registers the configured search paths' do
        # FIXME: We should not need to check against absolute paths (must never
        # be needed or used).
        expect(env.paths).to match_array [
          File.join(env.root, paths[0]),
          File.join(env.root, paths[1])
        ]
      end
    end
  end
end
