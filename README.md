z'assets
========

z'assets is a tool to manage assets for your web application. It uses
sprockets to handle the assets and sprockets-helpers to provide
required helpers.

Currently the following asset kinds are handled:

  * JavaScript
  * CoffeeScript
  * CSS
  * LESS


Usage
-----

Create a `config/zassets.yaml` file in your app:

    verbose: false
    host: ::1
    port: 9292
    base_url: '/assets'
    paths:
      - 'assets/styles'
    public_path: 'public'
    compile_path: 'public/assets'
    compile:
      - 'main.css'

Then you can launch development HTTP server with the following command:

    zassets serve

And compile your assets:

    zassets

You can override some config options using command line arguments, the
complete list is printed on the standard output on `zassets --help`.


Installation
------------

Assuming you have a working rubygems installation:

    gem install zassets
