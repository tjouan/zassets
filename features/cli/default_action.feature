Feature: Default action (build)

  Scenario: uses build as the default action when none is provided
    When I successfully run `zassets`
    Then it must build
