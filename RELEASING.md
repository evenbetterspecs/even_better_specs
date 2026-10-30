# Releasing

Releases are published to [RubyGems](https://rubygems.org/gems/even_better_specs) with Bundler's
`rake release` task. It builds the gem, creates and pushes a `vX.Y.Z` git tag, and pushes the gem.

## One-time setup

1. Have a [RubyGems account](https://rubygems.org/sign_up) with MFA enabled
   (the gemspec sets `rubygems_mfa_required`, so every push asks for an OTP code).
2. Sign in once: `gem signin`.
3. Have push access to the git remote (`git remote -v` must show `origin`).

## Cutting a release

1. Start from an up-to-date, clean `main`:

   ```sh
   git checkout main && git pull
   git status  # must be clean
   ```

2. Make sure the suite passes:

   ```sh
   bundle exec rspec
   ```

3. Pick the new version following [Semantic Versioning](https://semver.org/):
   - **patch** (`0.1.0` → `0.1.1`): bug fixes and false-positive fixes.
   - **minor** (`0.1.0` → `0.2.0`): new cops or new config options.
     New offenses can fail users' CI, so new cops are never a patch release.
   - **major** (`0.x` → `1.0.0`): removed or renamed cops, changed defaults that break existing setups.

4. Bump `VERSION` in `lib/even_better_specs/version.rb`.

5. Update `CHANGELOG.md`: rename `## [Unreleased]` to `## [X.Y.Z] - YYYY-MM-DD`, then add a new
   empty `## [Unreleased]` section above it. Group entries under `Added`, `Changed`, `Fixed` or `Removed`.

6. Commit the release:

   ```sh
   git add lib/even_better_specs/version.rb CHANGELOG.md
   git commit -m "Release vX.Y.Z"
   ```

7. Try the built gem locally before publishing:

   ```sh
   bundle exec rake install   # builds pkg/even_better_specs-X.Y.Z.gem and installs it
   cd /path/to/some/rails_app && even_better_specs spec/models
   ```

8. Publish:

   ```sh
   bundle exec rake release
   ```

   This pushes the commit and the `vX.Y.Z` tag to `origin`, then pushes the gem to RubyGems
   (enter the OTP code when asked).

9. Check <https://rubygems.org/gems/even_better_specs> shows the new version, then confirm it installs:

   ```sh
   gem install even_better_specs -v X.Y.Z
   ```

## If something goes wrong

- **`rake release` failed after tagging but before the gem push:** fix the problem, then push the
  gem alone with `gem push pkg/even_better_specs-X.Y.Z.gem`.
- **A broken version was published:** RubyGems does not allow re-pushing the same version. Run
  `gem yank even_better_specs -v X.Y.Z`, fix it, and release the next patch version.
  A yanked version number can never be reused.
