# frozen_string_literal: true

module RuboCop
  module Cop
    module EvenBetterSpecs
      # Write request specs instead of controller specs.
      #
      # @example
      #   # bad
      #   describe UsersController, type: :controller do
      #
      #   # good
      #   describe UsersController, type: :request do
      class RequestSpecs < Base
        MSG = "Write request specs instead of controller specs."

        def_node_matcher :controller_type?, "(pair (sym :type) (sym :controller))"

        def on_pair(node)
          add_offense(node) if controller_type?(node)
        end
      end
    end
  end
end
