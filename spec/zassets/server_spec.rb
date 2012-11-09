require 'spec_helper'

module ZAssets
  describe Server do
    let(:config)      { Config.new }
    subject(:server)  { Server.new(config) }

    describe '#run' do
      let(:handler) { double 'handler' }

      it 'runs the rack app' do
        server.stub(:handler) { handler }
        handler.should_receive(:run).with(server.app, server.options)
        server.run
      end
    end

    describe '#handler' do
      it 'returns the configured rack handler' do
        server.handler.should == Rack::Handler::Puma
      end
    end

    describe '#options' do
      it 'sets rack environment to development' do
        server.options[:environment].should == :development
      end

      it 'sets rack handler host to configured host' do
        server.options[:Host].should == config[:host]
      end

      it 'sets rack handler port to configured port' do
        server.options[:Port].should == config[:port]
      end
    end

    describe '#app' do
      it 'returns a rack application' do
        server.app.should respond_to(:call)
      end

      it 'builds the rack app once' do
        # When building a rack app with Rack::Builder.new, the app will be
        # built on each request. We dont want that so we need to either build
        # using Rack::Builder.app or call #to_app on the returned instance. We
        # can test if it was done by checking #to_app method absence.
        server.app.should_not respond_to(:to_app)
      end

      context 'Rack application' do
        include FixturesHelpers

        let(:app) { Rack::MockRequest.new(server.app) }

        it 'logs queries' do
          app.get('/').errors.should =~ /GET \/.+404.+/
        end

        it 'shows exceptions' do
          SprocketsEnv.any_instance.stub(:call) { raise RuntimeError }
          response = app.get(config[:base_url])
          response.should be_server_error
          response.should =~ /RuntimeError/
        end

        context 'assets mount point' do
          let(:config) { Config.new(paths: [fixture_path_for('assets')]) }

          it 'maps the sprockets env' do
            within_fixture_path do
              response = app.get([config[:base_url], 'app.js'].join('/'))
              response.should be_ok
              response.content_type.should == 'application/javascript'
              response.body.should == "console.log('hello!');\n"
            end
          end
        end

        context 'root mount point' do
          it 'maps the static file handler' do
            within_fixture_path do
              response = app.get('/hello.txt')
              response.should be_ok
              response.content_type.should == 'text/plain'
              response.body.should == "hello!\n"
            end
          end

          context 'when a public file is configured' do
            let(:config) { Config.new(public_file: 'index.html') }

            it 'serves the public file' do
              within_fixture_path do
                response = app.get('/')
                response.should be_ok
                response.content_type.should == 'text/html'
                response.body.should == "hello HTML!\n"
              end
            end
          end
        end
      end
    end
  end
end
