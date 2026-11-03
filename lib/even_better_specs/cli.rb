# frozen_string_literal: true

require "pathname"

module EvenBetterSpecs
  # Runs RuboCop with the gem's config, plus the `--diff[=BASE]` option.
  module CLI
    AUTOCORRECT_FLAGS = %w[-a -A -x --autocorrect --autocorrect-all --fix-layout].freeze

    def self.run(argv)
      args = argv.dup
      flag = args.find { |arg| arg == "--diff" || arg.start_with?("--diff=") }
      return rubocop(args) unless flag

      args.delete(flag)
      if args.intersect?(AUTOCORRECT_FLAGS)
        warn "--diff cannot be combined with autocorrect: it would rewrite lines outside the diff."
        return 2
      end

      base = flag.include?("=") ? flag.split("=", 2).last : "HEAD"
      Diff.changed_lines = Diff.compute(base)
      if Diff.changed_lines.empty?
        warn "No changes since #{base}."
        return 0
      end

      # Without explicit paths, inspect only the changed files that the config's Include matches.
      if args.none? { |arg| File.exist?(arg) }
        cwd = Pathname.new(File.realpath(Dir.pwd))
        files = Diff.changed_lines.keys.map { |file| Pathname.new(file).relative_path_from(cwd).to_s }
        args += ["--only-recognized-file-types", *files]
      end
      rubocop(args)
    rescue ArgumentError => e
      warn e.message
      2
    ensure
      Diff.changed_lines = nil
    end

    def self.rubocop(args)
      # --config makes RuboCop ignore the project's own .rubocop.yml (if any).
      RuboCop::CLI.new.run(["--config", CONFIG, *args])
    end
  end
end
