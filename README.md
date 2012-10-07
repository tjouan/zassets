z'assets
========

  z'assets is a tool based on [Sprockets][] for serving and compiling
web assets. When serving over HTTP (intended for a development
environment), compilation through various preprocessors will happen on
the fly. For production environment all specified assets are built as
files in a directory tree similar to their sources, except filenames
will include a hash to help caching.

[Sprockets]: https://github.com/sstephenson/sprockets

  Integration should be doable in any web application written in any
language, provided that you can parse JSON.

  Currently the following asset kinds are handled:

  * JavaScript
  * CoffeeScript
  * CSS
  * LESS (with a modified version of tilt original less engine)
  * Static files


Usage
-----

  Create a `config/zassets.yaml` file in your application root
directory:

    base_url: '/assets'
    paths:
      - 'assets/styles'
      - 'assets/scripts'
    public_path: 'public'
    compile_path: 'public/assets'
    compile:
      - 'main.css'

  Then you can launch development HTTP server with the following
command:

    zassets serve

  And build your assets:

    zassets compile

  You can override some config options using command line arguments,
the complete list is printed on the standard output on
`zassets --help`.


Installation
------------

  Assuming you have a working rubygems installation:

    gem install zassets


Similar projects
----------------

  FIXME


TODO
----

  * Replace compile argument (config?) with build?

  * Verify how sprockets-helpers is useful and either add usages
    in documentation or remove it.
