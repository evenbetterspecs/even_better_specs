# frozen_string_literal: true

require "json"
require "stringio"
require "tmpdir"
require "even_better_specs"

module CopHelper
  # Runs the gem's CLI config against `source` and returns the offending cop names.
  def offenses(source)
    Dir.mktmpdir do |dir|
      path = File.join(dir, "example_spec.rb")
      File.write(path, source)
      stdout = $stdout
      $stdout = StringIO.new
      RuboCop::CLI.new.run(["--config", EvenBetterSpecs::CONFIG, "--cache", "false", "--format", "json", path])
      JSON.parse($stdout.string).fetch("files").flat_map { |file| file["offenses"].map { |o| o["cop_name"] } }
    ensure
      $stdout = stdout
    end
  end
end

RSpec.configure do |config|
  config.include CopHelper
  config.disable_monkey_patching!
  config.define_derived_metadata { |meta| meta[:aggregate_failures] = true }
end
