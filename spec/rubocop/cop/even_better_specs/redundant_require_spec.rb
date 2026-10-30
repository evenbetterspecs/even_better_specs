# frozen_string_literal: true

RSpec.describe RuboCop::Cop::EvenBetterSpecs::RedundantRequire do
  it "flags and autocorrects require 'rails_helper'" do
    Dir.mktmpdir do |dir|
      path = File.join(dir, "user_spec.rb")
      File.write(path, "require 'rails_helper'\n\ndescribe User do\nend\n")

      expect(offenses(File.read(path))).to eq(["EvenBetterSpecs/RedundantRequire"])

      stdout = $stdout
      $stdout = StringIO.new
      RuboCop::CLI.new.run(["--config", EvenBetterSpecs::CONFIG, "--cache", "false", "-a", path])
      $stdout = stdout

      expect(File.read(path)).to eq("describe User do\nend\n")
    end
  end
end
