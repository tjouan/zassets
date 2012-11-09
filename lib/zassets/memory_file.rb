module ZAssets
  class MemoryFile
    def initialize(file)
      @file = file
    end

    def headers
      {
        'Content-Type'    => 'text/html',
        'Content-Length'  => body.length.to_s
      }
    end

    def body
      @content ||= @file.read
    end

    def call(env)
      [200, headers, [body]]
    end
  end
end
