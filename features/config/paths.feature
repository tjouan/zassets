Feature: Default load path

  Scenario: `paths' option defaults to `app'
    Given this config file:
      """
      build:
        - app.js
      """
    And a file named "app/app.js" with "some_content"
    When I build
    Then the built file "public/assets/app-*.js" must exist
