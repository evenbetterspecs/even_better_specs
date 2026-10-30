# frozen_string_literal: true

require "rubocop"
require "rubocop-rspec"
require_relative "even_better_specs/version"

module EvenBetterSpecs
  CONFIG = File.expand_path("../config/default.yml", __dir__)
end

Dir[File.join(__dir__, "rubocop/cop/even_better_specs/*.rb")].each { |file| require file }
