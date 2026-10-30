# frozen_string_literal: true

module RuboCop
  module Cop
    module EvenBetterSpecs
      # Remove `require 'rails_helper'` / `require 'spec_helper'` from spec files.
      # Use `--require rails_helper` in `.rspec` instead.
      #
      # @example
      #   # bad
      #   require 'rails_helper'
      #
      #   describe User do
      #   end
      #
      #   # good
      #   describe User do
      #   end
      class RedundantRequire < Base
        extend AutoCorrector
        include RangeHelp

        MSG = "Remove redundant `require`. Use `--require %<helper>s` in `.rspec` instead."
        RESTRICT_ON_SEND = %i[require].freeze

        def_node_matcher :helper_require, "(send nil? :require (str ${\"rails_helper\" \"spec_helper\"}))"

        def on_send(node)
          helper = helper_require(node)
          return unless helper

          add_offense(node, message: format(MSG, helper: helper)) do |corrector|
            corrector.remove(range_with_surrounding_space(node.source_range, side: :right))
          end
        end
      end
    end
  end
end
