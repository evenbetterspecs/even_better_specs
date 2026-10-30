# frozen_string_literal: true

module RuboCop
  module Cop
    module EvenBetterSpecs
      # Sibling examples with the same arrange and act steps should be one example
      # with several expectations.
      #
      # @example
      #   # bad
      #   it 'returns 200' do
      #     get user_path(user)
      #     expect(response.code).to eq('200')
      #   end
      #
      #   it 'returns JSON content type' do
      #     get user_path(user)
      #     expect(response.content_type).to eq('application/json')
      #   end
      #
      #   # good
      #   it 'responds with 200 http status and a JSON content type' do
      #     get user_path(user)
      #     expect(response.code).to eq('200')
      #     expect(response.content_type).to eq('application/json')
      #   end
      class GroupExpectations < RuboCop::Cop::RSpec::Base
        MSG = "Same setup as a sibling example. Group the expectations in a single example."
        EXPECTATIONS = %i[expect expect_any_instance_of is_expected are_expected should should_not].freeze

        def on_block(node)
          return unless example_group_with_body?(node)

          seen = {}
          node.body.each_child_node(:block).select { |child| example?(child) }.each do |example|
            setup = setup_source(example)
            next if setup.empty?

            seen.key?(setup) ? add_offense(example.send_node) : seen[setup] = true
          end
        end

        private

        def setup_source(example)
          statements = example.body&.begin_type? ? example.body.children : [example.body].compact
          statements.reject { |statement| expectation?(statement) }.map(&:source).join("\n")
        end

        def expectation?(statement)
          statement.each_node(:send).any? { |send| EXPECTATIONS.include?(send.method_name) }
        end
      end
    end
  end
end
