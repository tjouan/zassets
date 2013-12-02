require 'spec_helper'

describe ZAssets::MemoryFile do
  include FixturesHelpers

  let(:file_path) { fixture_path_for('public/index.html') }
  let(:file)      { File.new file_path }
  let(:subject)   { described_class.new(file) }

  describe '#headers' do
    it 'sets the content type to text/html' do
      expect(subject.headers['Content-Type']).to eq 'text/html'
    end

    it 'sets the content length to the file length' do
      expect(subject.headers['Content-Length']).to eq file.size.to_s
    end
  end

  describe '#body' do
    it 'returns the file content' do
      expect(subject.body).to eq File.read(file_path)
    end
  end

  describe '#call' do
    require 'rack'

    let(:app)       { Rack::MockRequest.new(subject) }
    let(:response)  { app.get('/') }

    it 'returns a successful response' do
      expect(response).to be_ok
    end

    it 'sets required headers' do
      expect(response.headers).to eq subject.headers
    end

    it 'returns the body' do
      expect(response.body).to eq subject.body
    end
  end
end
