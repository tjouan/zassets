@server
Feature: `public_file' option feature

  Background:
    Given a directory named "public"
    And a file named "public/index.html" with:
      """
      some_index
      """

  Scenario: serves file path set for `public_file' when resource not found
    Given the server is running with this config:
    """
    public_file: index.html
    """
    When I request "/inexistent_path"
    Then the response status must be 200
    And the body must be "some_index\n"
