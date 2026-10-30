# frozen_string_literal: true

module RuboCop
  module Cop
    module EvenBetterSpecs
      # Descriptions must not be longer than `Max` characters nor span many lines.
      # Split them using `context`.
      #
      # @example
      #   # bad
      #   it 'returns 422 when user first_name is missing from params and when user last_name is missing' do
      #
      #   # good
      #   context 'when user first_name is missing from params' do
      #     it 'returns 422' do
      class ShortDescription < RuboCop::Cop::RSpec::Base
        MSG = "Keep descriptions under %<max>d characters and on a single line. Split them using `context`."

        def_node_matcher :description, "(block (send #rspec? _ ${str dstr} ...) ...)"

        def on_block(node)
          return unless example?(node) || example_group?(node)

          text = description(node)
          return unless text

          length = text.str_type? ? text.value.length : text.source.length
          return unless text.multiline? || length > max

          add_offense(text, message: format(MSG, max: max))
        end

        private

        def max
          cop_config.fetch("Max", 100)
        end
      end
    end
  end
end
