@server
Feature: Configurable rack handler

  Scenario: uses puma as the default rack handler
    Given the server is running
    Then the rack handler must be "puma"

  Scenario: uses the configured rack handler
    Given the server is running with this config:
    """
    server: webrick
    """
    Then the rack handler must be "webrick"
