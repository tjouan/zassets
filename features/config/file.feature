Feature: Config file loading

  Scenario: loads options from `config/zassets.yaml' when this file exists
    Given a file named "config/zassets.yaml" with:
      """
      &* invalid yaml
      """
    When I run `zassets compile`
    Then it must fail to parse the config
    And the output must contain "config/zassets.yaml"
