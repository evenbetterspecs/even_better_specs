# frozen_string_literal: true

module RuboCop
  module Cop
    module EvenBetterSpecs
      # Use `subject` instead of `described_class.new` when no argument is given.
      #
      # @example
      #   # bad
      #   calculator = described_class.new
      #
      #   # good
      #   subject.add(1, 2)
      #   subject = described_class.new(5)
      class UseSubject < Base
        MSG = "Use `subject` instead of `described_class.new` without arguments."
        RESTRICT_ON_SEND = %i[new].freeze

        def_node_matcher :described_class_new?, "(send (send nil? :described_class) :new)"

        def on_send(node)
          add_offense(node) if described_class_new?(node)
        end
      end
    end
  end
end
