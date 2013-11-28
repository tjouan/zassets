Feature: CLI usage

  Scenario: prints the usage when -h argument is given
    When I successfully run `zassets -h`
    Then the output must contain:
      """
      Usage: zassets [options] [build|serve]
      """
