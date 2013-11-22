@server
Feature: Static files server

  Background:
    Given a directory named "public"
    And a file named "public/some_file" with:
      """
      some_content
      """

  Scenario: serves files in `public' directory
    Given the server is running
    When I request "/some_file"
    Then the response status must be 200
    And the body must be "some_content\n"
