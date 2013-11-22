Feature: CoffeeScript transpiler

  Scenario: transpiles *.coffee files
    Given this config file:
      """
      paths:
        - app
      compile:
        - app.js
      """
    And a file named "app/app.coffee" with:
      """
      my_var = value
      """
    When I build
    Then the built file "public/assets/app-*.js" must match /var\s+my_var/
