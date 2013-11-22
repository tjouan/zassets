@server
Feature: Logging on standard output

  Scenario: logs requests on standard output
    Given the server is running
    When I request "/some_path"
    Then the server output must match /::1.+GET\s+\/some_path\s+.*404/
