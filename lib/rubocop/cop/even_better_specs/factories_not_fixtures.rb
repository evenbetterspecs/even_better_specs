# frozen_string_literal: true

module RuboCop
  module Cop
    module EvenBetterSpecs
      # Use factories instead of fixtures.
      #
      # @example
      #   # bad
      #   fixtures :users
      #
      #   # good
      #   user = create(:user)
      class FactoriesNotFixtures < Base
        MSG = "Use factories instead of fixtures."
        RESTRICT_ON_SEND = %i[fixtures].freeze

        def on_send(node)
          add_offense(node) if node.receiver.nil?
        end
      end
    end
  end
end
