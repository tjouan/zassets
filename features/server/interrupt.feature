Feature: SIGINT handling

  Scenario: exits after SIGINT signal is received
    Given the server is running
    When I send the SIGINT signal
    Then the server must stop successfully
