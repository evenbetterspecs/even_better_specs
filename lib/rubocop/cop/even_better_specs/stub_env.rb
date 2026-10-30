# frozen_string_literal: true

module RuboCop
  module Cop
    module EvenBetterSpecs
      # Stub environment variables instead of changing `ENV`.
      #
      # @example
      #   # bad
      #   ENV['SALES_TEAM_EMAIL'] = 'sales-group@company.com'
      #
      #   # good
      #   stub_env('SALES_TEAM_EMAIL', 'sales-group@company.com')
      class StubEnv < Base
        MSG = "Stub environment variables (e.g. `stub_env`) instead of changing `ENV`."
        RESTRICT_ON_SEND = %i[[]= store update merge! delete replace clear].freeze

        def_node_matcher :env?, "(const {nil? cbase} :ENV)"

        def on_send(node)
          add_offense(node) if env?(node.receiver)
        end
      end
    end
  end
end
