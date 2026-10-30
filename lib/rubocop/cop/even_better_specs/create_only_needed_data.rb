# frozen_string_literal: true

module RuboCop
  module Cop
    module EvenBetterSpecs
      # Create only the data you need. Flags `*_list` factory calls above `Max` records.
      #
      # @example Max: 2 (default)
      #   # bad
      #   create_list(:product, 5)
      #
      #   # good
      #   create(:product, featured: false)
      class CreateOnlyNeededData < Base
        MSG = "Create only the data you need (%<count>d records, max %<max>d)."
        RESTRICT_ON_SEND = %i[create_list build_list build_stubbed_list attributes_for_list].freeze

        def_node_matcher :list_count, "(send {nil? (const {nil? cbase} :FactoryBot)} _ _ (int $_) ...)"

        def on_send(node)
          count = list_count(node)
          max = cop_config.fetch("Max", 3)
          return unless count && count > max

          add_offense(node, message: format(MSG, count: count, max: max))
        end
      end
    end
  end
end
