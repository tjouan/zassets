Feature: Version information

  Scenario: prints the version when -V argument is given
    When I successfully run `zassets -V`
    Then the output must match /\A\d+\.\d+\.\d+\n\z/
