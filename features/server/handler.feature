@server
Feature: Configurable rack handler

  Scenario: uses the configured rack handler
    Given the server is running with this config:
    """
    server: webrick
    """
    Then the rack handler must be "webrick"
