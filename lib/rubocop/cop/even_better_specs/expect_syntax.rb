# frozen_string_literal: true

module RuboCop
  module Cop
    module EvenBetterSpecs
      # Always use `expect` instead of `should`.
      #
      # @example
      #   # bad
      #   response.code.should eq('200')
      #   it { should eq('200') }
      #
      #   # good
      #   expect(response.code).to eq('200')
      #   it { is_expected.to eq('200') }
      class ExpectSyntax < Base
        MSG = "Use `expect` instead of `%<method>s`."
        RESTRICT_ON_SEND = %i[should should_not].freeze

        def on_send(node)
          add_offense(node.loc.selector, message: format(MSG, method: node.method_name))
        end
      end
    end
  end
end
