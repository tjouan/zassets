Feature: Plugin configuration

  Scenario: accepts hash in plugins keys for plugin configuration
    Given this config file:
      """
      plugins:
        - name: my_plugin
          foo: :testing_plugin_config
      """
    And a file named "zassets-plugins-my_plugin.rb" with:
      """
      module ZAssets
        module Plugins
          module MyPlugin
            class Registrant
              def initialize config
                puts config[:plugins].first[:foo].inspect
              end

              def register; end
            end
          end
        end
      end
      """
    When I run `ruby -I. -rzassets-plugins-my_plugin -S zassets`
    Then the output must contain ":testing_plugin_config"
