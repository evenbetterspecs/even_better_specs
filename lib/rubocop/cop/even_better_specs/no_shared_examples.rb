# frozen_string_literal: true

module RuboCop
  module Cop
    module EvenBetterSpecs
      # Do not use shared examples or shared contexts.
      #
      # @example
      #   # bad
      #   shared_examples 'a barking animal' do
      #   it_behaves_like 'a barking animal'
      #
      #   # good
      #   it 'barks' do
      #     expect(subject.able_to_bark?).to eq(true)
      #   end
      class NoSharedExamples < Base
        MSG = "Do not use `%<method>s`. Write self-contained examples."
        RESTRICT_ON_SEND = %i[
          shared_examples shared_examples_for shared_context
          it_behaves_like it_should_behave_like include_examples include_context
        ].freeze

        def_node_matcher :rspec_receiver?, "{nil? (const {nil? cbase} :RSpec)}"

        def on_send(node)
          return unless rspec_receiver?(node.receiver)

          add_offense(node, message: format(MSG, method: node.method_name))
        end
      end
    end
  end
end
