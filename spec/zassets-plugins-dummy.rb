# Dummy zassets plugin for testing purpose.

module ZAssets
  module Plugins
    module Dummy
      class Registrant
        def initialize(config)
          @config = config
        end

        def register
          @config[:dummy_plugin] = :registered
        end
      end
    end
  end
end
