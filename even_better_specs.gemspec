# frozen_string_literal: true

require_relative "lib/even_better_specs/version"

Gem::Specification.new do |spec|
  spec.name = "even_better_specs"
  spec.version = EvenBetterSpecs::VERSION
  spec.authors = ["Glauco Custodio"]
  spec.email = ["glauco.custodio@gmail.com"]
  spec.summary = "RuboCop cops for the Even Better Specs guidelines"
  spec.description = "Enforces https://evenbetterspecs.github.io with RuboCop. Ships its own CLI so it runs " \
                     "in projects that do not have rubocop in their Gemfile."
  spec.homepage = "https://evenbetterspecs.github.io"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1"

  spec.files = Dir["lib/**/*.rb", "config/*.yml", "exe/*", "README.md", "CHANGELOG.md"]
  spec.bindir = "exe"
  spec.executables = ["even_better_specs"]

  spec.add_dependency "rubocop", "~> 1.72"
  spec.add_dependency "rubocop-rspec", "~> 3.5"
  spec.metadata["source_code_uri"] = "https://github.com/evenbetterspecs/even_better_specs"
  spec.metadata["changelog_uri"] = "https://github.com/evenbetterspecs/even_better_specs/blob/main/CHANGELOG.md"
  spec.metadata["bug_tracker_uri"] = "https://github.com/evenbetterspecs/even_better_specs/issues"
  spec.metadata["rubygems_mfa_required"] = "true"
end
