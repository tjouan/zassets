Feature: Version information

  Scenario: prints the version when -v argument is given
    When I successfully run `zassets -V`
    Then the output must match /\A\d+\.\d+\.\d+\n\z/
