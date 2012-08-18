require 'tilt'
require 'less'

module Sprockets
  class LessTemplate < Tilt::Template
    self.default_mime_type = 'text/css'

    def self.engine_initialized?
      defined? ::Less
    end

    def initialize_engine
      require_template_library 'less'
    end

    def prepare
    end

    def evaluate(context, locals, &block)
      options = {
        :filename => eval_file,
        :paths => [File.dirname(eval_file)]
      }
      parser = ::Less::Parser.new(options)
      tree = parser.parse(data)
      depend_on(context, eval_file)
      tree.to_css
    rescue ::Less::ParseError => e
      context.__LINE__ = e.line
      raise e
    end

    def depend_on(context, path)
      parser = ::Less::Parser.new({
        :filename => path,
        :paths    => [File.dirname(path)]
      })
      parser.parse(File.read(path))
      parser.imports.each do |i|
        dependency_path = File.join(File.dirname(path), i)
        context.depend_on(dependency_path)
        depend_on(context, dependency_path)
      end
    end
  end
end
