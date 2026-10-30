# frozen_string_literal: true

module RuboCop
  module Cop
    module EvenBetterSpecs
      # Avoid hooks. Arrange everything inside each example.
      #
      # @example
      #   # bad
      #   before do
      #     sign_in user
      #   end
      #
      #   # good
      #   it 'returns 200' do
      #     sign_in user
      #   end
      class NoHooks < RuboCop::Cop::RSpec::Base
        MSG = "Avoid hooks. Arrange everything inside the example."

        def on_block(node)
          add_offense(node.send_node) if hook?(node)
        end
        alias on_numblock on_block
      end
    end
  end
end
