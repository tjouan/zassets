Feature: Plugin loading

  Scenario: loads configured plugins
    Given this config file:
      """
      plugins:
        - my_plugin
      """
    And a file named "zassets-plugins-my_plugin.rb" with:
      """
      module ZAssets
        module Plugins
          module MyPlugin
            class Registrant
              def initialize _; end

              def register
                puts 'testing_plugin_loading'
              end
            end
          end
        end
      end
      """
    When I run `ruby -I. -rzassets-plugins-my_plugin -S zassets`
    Then the output must contain "testing_plugin_loading"
