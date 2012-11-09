require 'spec_helper'

describe ZAssets::MemoryFile do
  include FixturesHelpers

  let(:file_path) { fixture_path_for('public/index.html') }
  let(:file)      { File.new file_path }
  let(:subject)   { described_class.new(file) }

  describe '#headers' do
    it 'sets the content type to text/html' do
      subject.headers['Content-Type'].should == 'text/html'
    end

    it 'sets the content length to the file length' do
      subject.headers['Content-Length'].should == file.size.to_s
    end
  end

  describe '#body' do
    it 'returns the file content' do
      subject.body.should == File.read(file_path)
    end
  end

  describe '#call' do
    require 'rack'

    let(:app)       { Rack::MockRequest.new(subject) }
    let(:response)  { app.get('/') }

    it 'returns a successful response' do
      response.should be_ok
    end

    it 'sets required headers' do
      response.headers.should == subject.headers
    end

    it 'returns the body' do
      response.body.should == subject.body
    end
  end
end
