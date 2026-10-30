# frozen_string_literal: true

module RuboCop
  module Cop
    module EvenBetterSpecs
      # A `describe` with a single `context` most likely misses the edge and invalid cases.
      #
      # @example
      #   # bad
      #   describe '#destroy' do
      #     context 'when the product exists' do
      #     end
      #   end
      #
      #   # good
      #   describe '#destroy' do
      #     context 'when the product exists' do
      #     end
      #
      #     context 'when the product does not exist' do
      #     end
      #   end
      class AllPossibleCases < RuboCop::Cop::RSpec::Base
        MSG = "Only one `context` here. Test valid, edge and invalid cases."

        def_node_matcher :describe?, "(block (send #rspec? :describe ...) ...)"
        def_node_matcher :context?, "(block (send nil? :context ...) ...)"

        def on_block(node)
          return unless describe?(node) && node.body && context?(node.body)

          add_offense(node.send_node)
        end
      end
    end
  end
end
