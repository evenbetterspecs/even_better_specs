# frozen_string_literal: true

module RuboCop
  module Cop
    module EvenBetterSpecs
      # Do not use `let` / `let!`. Define the data inside each example.
      #
      # @example
      #   # bad
      #   let(:user) { build(:user) }
      #
      #   # good
      #   it 'returns the full name' do
      #     user = build(:user)
      #   end
      class NoLet < Base
        MSG = "Do not use `%<method>s`. Define the data inside the example."
        RESTRICT_ON_SEND = %i[let let!].freeze

        def on_send(node)
          add_offense(node, message: format(MSG, method: node.method_name)) if node.receiver.nil?
        end
      end
    end
  end
end
