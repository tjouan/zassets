require 'spec_helper'

module ZAssets
  describe Server do
    let(:config)      { Config.new }
    subject(:server)  { Server.new(config) }

    describe '#run' do
      let(:handler) { double 'handler' }

      it 'runs the rack app' do
        allow(server).to receive(:handler) { handler }
        expect(handler).to receive(:run).with(server.app, server.options)
        server.run
      end
    end

    describe '#handler' do
      it 'returns the configured rack handler' do
        expect(server.handler).to eq Rack::Handler::Puma
      end
    end

    describe '#options' do
      it 'sets rack environment to development' do
        expect(server.options[:environment]).to eq :development
      end

      it 'sets rack handler host to configured host' do
        expect(server.options[:Host]).to eq config[:host]
      end

      it 'sets rack handler port to configured port' do
        expect(server.options[:Port]).to eq config[:port]
      end
    end

    describe '#app' do
      it 'returns a rack application' do
        expect(server.app).to respond_to(:call)
      end

      it 'builds the rack app once' do
        # When building a rack app with Rack::Builder.new, the app will be
        # built on each request. We dont want that so we need to either build
        # using Rack::Builder.app or call #to_app on the returned instance. We
        # can test if it was done by checking #to_app method absence.
        expect(server.app).not_to respond_to(:to_app)
      end

      context 'Rack application' do
        include FixturesHelpers

        let(:app) { Rack::MockRequest.new(server.app) }

        it 'logs queries' do
          expect(app.get('/').errors).to match(/GET \/.+404.+/)
        end

        it 'shows exceptions' do
          allow_any_instance_of(SprocketsEnv).to receive(:call) { raise RuntimeError }
          response = app.get(config[:base_url])
          expect(response).to be_server_error
          expect(response).to match(/RuntimeError/)
        end

        context 'assets mount point' do
          let(:config) { Config.new(paths: [fixture_path_for('assets')]) }

          it 'maps the sprockets env' do
            within_fixture_path do
              response = app.get([config[:base_url], 'app.js'].join('/'))
              expect(response).to be_ok
              expect(response.content_type).to eq 'application/javascript'
              expect(response.body).to eq "console.log('hello!');\n"
            end
          end
        end

        context 'root mount point' do
          it 'maps the static file handler' do
            within_fixture_path do
              response = app.get('/hello.txt')
              expect(response).to be_ok
              expect(response.content_type).to eq 'text/plain'
              expect(response.body).to eq "hello!\n"
            end
          end

          context 'when a public file is configured' do
            let(:config) { Config.new(public_file: 'index.html') }

            it 'serves the public file' do
              within_fixture_path do
                response = app.get('/')
                expect(response).to be_ok
                expect(response.content_type).to eq 'text/html'
                expect(response.body).to eq "hello HTML!\n"
              end
            end
          end
        end
      end
    end
  end
end
