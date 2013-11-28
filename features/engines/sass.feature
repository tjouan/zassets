Feature: SASS transpiler

  Scenario: transpiles *.sass files
    Given this config file:
      """
      paths:
        - app
      build:
        - styles/main.css
      """
    And a file named "app/styles/main.sass" with:
      """
      $gray_dark: #121212
      $white:     #d0d0d0

      html
        background-color: $gray_dark
        color: $white
      """
    When I build
    Then the built file "public/assets/styles/main-*.css" must match:
      """
      .*
      html\s*\{
        \s*
        background-color:\s*#121212\s*;
      .*
      """
