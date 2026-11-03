# frozen_string_literal: true

RSpec.describe EvenBetterSpecs::CLI do
  # Runs the CLI inside a fresh git repo and returns [exit status, ["path:line cop"], stderr].
  def run_in_repo(args, committed:, changed: {})
    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do
        RuboCop::PathUtil.reset_pwd # RuboCop memoizes the cwd
        system("git init -q && git config user.email t@t && git config user.name t", exception: true)
        committed.each { |path, source| File.write(path, source) }
        system("git add -A && git commit -qm init", exception: true)
        changed.each { |path, source| File.write(path, source) }

        stdout, stderr = $stdout, $stderr
        $stdout, $stderr = StringIO.new, StringIO.new
        status = described_class.run([*args, "--cache", "false", "--format", "json"])
        out, err = $stdout.string, $stderr.string
        $stdout, $stderr = stdout, stderr

        found = out.empty? ? [] : JSON.parse(out).fetch("files").flat_map do |file|
          file["offenses"].map { |o| "#{file["path"]}:#{o["location"]["line"]} #{o["cop_name"]}" }
        end
        [status, found, err]
      end
    end
  end

  describe ".run" do
    it "reports only offenses on lines changed since HEAD" do
      before_change = <<~RUBY
        describe User do
          let(:old) { 1 }
        end
      RUBY
      after_change = <<~RUBY
        describe User do
          let(:old) { 1 }
          let(:new) { 2 }
        end
      RUBY

      status, found, = run_in_repo(["--diff"], committed: { "user_spec.rb" => before_change },
                                               changed: { "user_spec.rb" => after_change })

      expect(found).to eq(["user_spec.rb:3 EvenBetterSpecs/NoLet"])
      expect(status).to eq(1)
    end

    it "reports every offense of an untracked spec and skips non-spec files" do
      source = "describe User do\n  let(:a) { 1 }\nend\n"

      _, found, = run_in_repo(["--diff=HEAD"], committed: { "README" => "x" },
                                               changed: { "new_spec.rb" => source, "app.rb" => source })

      expect(found).to eq(["new_spec.rb:2 EvenBetterSpecs/NoLet"])
    end

    context "when nothing changed" do
      it "exits successfully without inspecting" do
        status, found, err = run_in_repo(["--diff"], committed: { "user_spec.rb" => "describe User do\n  let(:a) { 1 }\nend\n" })

        expect([status, found, err]).to eq([0, [], "No changes since HEAD.\n"])
      end
    end

    context "when combined with autocorrect" do
      it "refuses to run" do
        status, _, err = run_in_repo(["--diff", "-a"], committed: { "README" => "x" }, changed: { "README" => "y" })

        expect(status).to eq(2)
        expect(err).to include("cannot be combined with autocorrect")
      end
    end
  end
end
