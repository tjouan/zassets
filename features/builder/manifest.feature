Feature: Manifest

  Scenario: builds a manifests of built assets
    Given this config file:
      """
      paths:
        - app
      compile:
        - app.js
      """
    And an empty file named "app/app.js"
    When I build
    Then the manifest should include build path for "app.js"
