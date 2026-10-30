# frozen_string_literal: true

module RuboCop
  module Cop
    module EvenBetterSpecs
      # Nested `describe` blocks name a method: `.class_method` or `#instance_method`.
      #
      # @example
      #   # bad
      #   describe 'the authenticate method for User' do
      #   describe 'GET #index' do
      #
      #   # good
      #   describe '.authenticate' do
      #   describe '#index' do
      class DescribeMethod < RuboCop::Cop::RSpec::Base
        MSG = "Describe a method using `.class_method` or `#instance_method`, or use `context`."

        def_node_matcher :describe_with_string, "(block (send #rspec? :describe $str ...) ...)"

        def on_block(node)
          description = describe_with_string(node)
          return unless description
          return if description.value.start_with?(".", "#")
          return unless node.each_ancestor(:block).any? { |ancestor| example_group?(ancestor) }

          add_offense(description)
        end
      end
    end
  end
end
