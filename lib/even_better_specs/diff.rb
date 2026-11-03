# frozen_string_literal: true

require "open3"

module EvenBetterSpecs
  # Limits a run to the lines added or changed since a git revision (`--diff`).
  module Diff
    HUNK = /\A@@ -\S+ \+(\d+)(?:,(\d+))? @@/
    WHOLE_FILE = [1..].freeze

    class << self
      # { absolute path => [line ranges] } while a `--diff` run is active, nil otherwise.
      attr_accessor :changed_lines

      # Changed line ranges per file since `base`. Untracked files count as changed in full,
      # like RuboCop's `--changed`.
      def compute(base)
        root = git("rev-parse", "--show-toplevel").chomp
        lines = parse(git("diff", "-U0", "--no-color", "--no-ext-diff", "--src-prefix=a/", "--dst-prefix=b/", base), root)
        git("ls-files", "--others", "--exclude-standard", "--full-name", chdir: root).each_line do |path|
          lines[File.join(root, path.chomp)] = WHOLE_FILE
        end
        lines
      end

      def parse(diff, root)
        file = nil
        diff.each_line.with_object({}) do |line, lines|
          if line.start_with?("+++ ")
            path = line.chomp.chomp("\t").delete_prefix("+++ ")
            file = path == "/dev/null" ? nil : File.join(root, path.delete_prefix("b/"))
          elsif file && (hunk = HUNK.match(line))
            start = hunk[1].to_i
            count = (hunk[2] || 1).to_i
            (lines[file] ||= []) << (start...start + count) if count.positive?
          end
        end
      end

      def changed?(file, line)
        # git reports real paths; RuboCop may hold a symlinked one (e.g. /tmp on macOS).
        changed_lines.fetch(File.realpath(file), []).any? { |range| range.cover?(line) }
      end

      private

      def git(*args, chdir: Dir.pwd)
        output, error, status = Open3.capture3("git", *args, chdir: chdir)
        raise ArgumentError, "git #{args.first} failed: #{error.strip}" unless status.success?

        output
      end
    end

    # Drops offenses outside the changed lines. Hooked after RuboCop's result cache, so the cache
    # keeps full results, and before reporting, so every formatter and the exit code agree.
    module RunnerFilter
      private

      def process_file(file)
        offenses = super
        return offenses unless Diff.changed_lines

        offenses.select { |offense| Diff.changed?(file, offense.line) }.freeze
      end
    end
  end
end

RuboCop::Runner.prepend(EvenBetterSpecs::Diff::RunnerFilter)
