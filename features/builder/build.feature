Feature: Builder

  Scenario: builds assets
    Given this config file:
      """
      paths:
        - app
      build:
        - app.js
      """
    And a file named "app/app.js" with "some_content"
    When I build
    Then the built file "public/assets/app-*.js" must exist
    And the built file "public/assets/app-*.js" must contain "some_content"
