z'assets - Assets server and builder
====================================

  zassets is both a server and a simple build tool for static web
sites. Assets are piped through various preprocessors or templating
engines (ERB, CoffeeScript, Sass…). A simple declarative dependency
management is also available, based on keywords you can include in
source files.

  It is best suited for the development of single page applications:
either using the built-in HTTP daemon as a development environment, or
building your application as static files in a common directory, ready
to be rsynced to a production server.

  Most of those behaviors will be very similar to Ruby on Rails "asset
pipeline", Sprockets, which is used internally.


Getting started
---------------

### Installation (need ruby and rubygems)

    $ gem install zassets

### Application template following zassets conventions

  Create a basic application:

``` sh
$ mkdir ~/tmp/my_app
$ cd ~/tmp/my_app                 # your app root directory
$ mkdir app                       # `app' is part of the load path
$ cat << 'EOH' > app/hello.coffee
console.log 'hello from my app!'
EOH
```

  `app` directory is the default load path, but this behavior is
configurable. Any asset in the load path might be submitted to
appropriate processors then served or built.

### Serving your application

``` sh
$ zassets serve
Puma 2.6.0 starting...            # Rack handler is configurable
* Min threads: 0, max threads: 16
* Environment: development
* Listening on tcp://::1:9292
```

  Check it works in your browser (here in a new shell for
documentation purpose).

``` sh
$ curl http://localhost:9292/assets/hello.js | head -n 2
(function() {
  console.log('hello from my app!');
```

### Building and packaging your application

  You need to specify the files you want to be built in a config file:

``` sh
$ mkdir config
$ cat << 'EOH' > config/zassets.yaml
build: hello.js
EOH
$ zassets
$ ls -1 public/assets
hello-3297995eead5225d053fb06facd15d3a.js
hello-3297995eead5225d053fb06facd15d3a.js.gz
manifest.json
$ head -n 2 public/assets/hello-3297995eead5225d053fb06facd15d3a.js
(function() {
  console.log('hello from my app!');
```

  `zassets` command is equivalent to `zassets build`, it will build
all files listed in the `build:` configuration key into
`public/assets` directory. A manifest in JSON format will also be
written in `public/assets/manifest.json` file.

### Command line usage help

  You can override some configuration options using command line
arguments, the complete list is printed on the standard output on
`zassets --help`.

``` sh
$ zassets -h
Usage: zassets [options] [build|serve]
    -v, --verbose                    Enable verbose mode
    -c, --config FILE                Load default options from FILE
    -o, --host HOST                  Listen on HOST (default: ::1)
    -p, --port PORT                  Listen on PORT (default: 9292)
    -s, --server SERVER              Use SERVER as Rack handler
    -h, --help                       Show this message
    -V, --version                    Show version
```


Internals overview
------------------

  Internally, zassets uses [Sprockets][] which provides most of the
current features, along with [Rack][]. zassets server will mount both
the Rack application provided by Sprockets and its own Rack
application, mostly for features related to serving static files.
Sprockets is also used fully when building assets, including
"fingerprinting" the built assets (inserting a computed hash in the
file name), which can be relied on to improve some HTTP caching
behaviors.

[Sprockets]: https://github.com/sstephenson/sprockets
[Rack]: http://rack.github.io/


Configuration
-------------

  Some options are available from the command line, but most can only
be modified by the use of a configuration file. By default zassets
will try to read a file named `config/zassets.yaml`.

  An additional specific configuration file can be specified with the
`-c` argument, it will be loaded after an eventual
`config/zassets.yaml` file.

### Extensive configuration file example with comments

  For accurate and up to date details, read `lib/zassets/config.rb`
source file.

``` yaml
# Enable verbose mode.
verbose: true

# List of plugins to load on startup.
plugins:
  - haml_coffee

# Bind server socket to localhost and listen on port 8000.
host: localhost
port: 8000

# Change rack handler (HTTP server) to unicorn (default is puma).
server: unicorn

# List of directories where assets will be searched for (load
# path).
paths:
  - app
  - vendor

# Path to a file served when no resource is found (catch all).
public_file: index.html

# URI path where sprockets rack application is mounted at.
base_url: /assets

# Path used as root directory when serving static files.
public_path: public

# Path used as output directory when building assets.
build_path: public/assets

# List of file paths specifying which files are part of the build.
build:
  - app.js
  - styles/main.css
```


Engines
-------

  "Engines" are preprocessors, transpilers, template languages… Some
are provided by Sprockets, and its ecosystem can provide a lot more.
zassets core will focus on CoffeeScript and Sass, but other engines
are available as plugins:

  * Haml Coffee
  * Emblem.js
  * Handlebars
  * LESS (Sprockets LESS engine will handle @import rules by querying
    assets "logical path", not relative path as it would be the case
    in classic LESS stylesheets, the plugin implement some
    workarounds). See:
    https://github.com/sstephenson/sprockets/pull/323


  More details in Sprockets README:
  https://github.com/sstephenson/sprockets#using-engines


JavaScript templating
---------------------

  FIXME: JST


  More details in Sprockets README:
  https://github.com/sstephenson/sprockets#javascript-templating-with-ejs-and-eco


Dependency management
---------------------

  Sprockets includes a "directive processor", allowing you to require
and manage your dependencies by placing special comments interpreted
by Sprockets as keywords.

  CoffeeScript example:

``` coffeescript
#= require jquery/jquery-1.9.1
#= require hamlcoffee
#= require underscore/underscore-1.4.4
#= require backbone/backbone-1.0.0

#= require_tree ./lib
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./collections
#= require_tree ./views
#= require_self
```


  Javascript example:

``` javascript
//= require jquery/jquery-1.9.1
```


  More details in Sprockets README:
  https://github.com/sstephenson/sprockets#managing-and-bundling-dependencies


Manifest
--------

  FIXME

``` sh
$ ruby -rjson -e \
  'puts JSON.pretty_generate(JSON.parse($stdin.read))' \
  < public/assets/manifest.json
{
  "files": {
    "hello-3297995eead5225d053fb06facd15d3a.js": {
      "logical_path": "hello.js",
      "mtime": "2013-11-28T23:11:04+00:00",
      "size": 67,
      "digest": "3297995eead5225d053fb06facd15d3a"
    }
  },
  "assets": {
    "hello.js": "hello-3297995eead5225d053fb06facd15d3a.js"
  }
}
```


Plugins
-------

FIXME


TODO
----

* Implement testing API, both for cucumber and rspec. Should provide a
  file to require for each framework, bringing instance methods,
  cucumber steps and easy access to test fixtures.
  possible use/inspiration:
    https://github.com/smartlogic/http_spec

* Must warn/fail when a file listed in `build:` option is not built.

* Serving static files and using `public_file:` catchall should work
  together.

* Implement compression for some assets kind when appropriate (JS,
  CSS).
  https://github.com/jcoglan/packr (compress javascript)

* Add support for Haml templates.

* Implement helpers like `asset_path` or similar things from rails so
  that we could include dynamic assets path via ERB or Haml template.
  https://github.com/maccman/stylo/blob/master/app.rb#L23-40

* Help manage vendored files (installing, updating)
  https://github.com/grosser/vendorer

* Check if we can optimize build process by porting code from:
  https://github.com/ndbroadbent/turbo-sprockets-rails3
  or with:
  `sprocket_env.cache = Sprockets::Cache::FileStore.new '/tmp'`

* Consider implementing some support for JavaScript "modules"
  packagers.
  https://github.com/sstephenson/sprockets/issues/298
  https://github.com/maccman/sprockets-commonjs

* Add a README section about integration in a non-ruby server runtime.


Similar/related code
--------------------

* https://github.com/sstephenson/sprockets
  Sprockets: Rack-based asset packaging

* http://rack.github.io/
  Rack: a Ruby Webserver Interface

* Sprockets contrib guide:
  https://github.com/radar/guides/blob/56da5701c470442c3ab96a0005023117eae58777/sprockets.md

### With features for static sites

* http://stasis.me/
  Stasis is a dynamic framework for static sites.

* http://mimosa.io/
  Loaded with what you need to start coding right away. Transpilers,
  Pre-Processors, Micro-templates, RequireJS, Bower, Testing and more.

* http://brunch.io/
  Brunch is an assembler for HTML5 applications. It's agnostic to
  frameworks, libraries, programming, stylesheet & templating
  languages and backend technology.

### Sprockets related

* https://github.com/petebrowne/machined
  A static site generator and Rack server built using Sprockets 2.0

* https://github.com/maccman/catapult
  Simple gem that gives pure JavaScript/CoffeeScript projects a basic
  structure, and manages any necessary compilation and concatenation.

### Rack related

* https://github.com/jlong/serve
  Serve is a small Rack-based web server that makes it easy to serve
  HTML, ERB, Haml, or a variety of template languages from any
  directory.

* https://github.com/Sutto/barista (transpile CoffeeScript)

### Rake related

* https://github.com/mcollina/rake-minify
  Rake Minify is an extremely simple solution for minifying javascript
  and coffeescript files using a rake task.

### Rails related

* http://documentcloud.github.io/jammit/
  Jammit is an industrial strength asset packaging library for Rails,
  providing both the CSS and JavaScript concatenation and compression
  that you'd expect, as well as YUI Compressor, Closure Compiler, and
  UglifyJS compatibility, ahead-of-time gzipping, built-in JavaScript
  template support, and optional Data-URI / MHTML image and font
  embedding.

* https://github.com/d-i/half-pipe (ruby gem, uses nodejs/grunt)
  Gem to replace the Rails asset pipeline with a Grunt.js-based
  workflow, providing dependencies via Bower.

### Sinatra related

* https://github.com/rstacruz/sinatra-assetpack
  The most convenient way to manage your assets in Sinatra.

### Building and/or packaging

* http://winton.github.io/smart_asset/
  Smart asset packaging for Rails, Sinatra, and Stasis

* https://github.com/cjohansen/juicer
  Juicer is a command line tool that helps you ship frontend code for
  production.

* https://github.com/jcoglan/jake
  Jake is a command-line line tool for building JavaScript packages
  from source code. It’s basically a thin wrapper around Packr that
  lets you easily configure builds for multiple packages with
  different compression settings, using a simple YAML config file.

### Miscellaneous

* http://harpjs.com/
  The static web server with built-in preprocessing.
