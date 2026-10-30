# Changelog

All notable changes to this project are documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project follows [Semantic Versioning](https://semver.org/).

## [Unreleased]

## [0.1.0] - 2026-10-30

### Added

- `even_better_specs` CLI that runs with its own config, so it works in projects without rubocop in their Gemfile.
- Cops for the Even Better Specs guidelines: `DescribeMethod`, `FactoriesNotFixtures`, `UseSubject`,
  `ShortDescription`, `GroupExpectations`, `AllPossibleCases` (info severity), `RequestSpecs`, `ExpectSyntax`,
  `RedundantRequire` (autocorrectable), `NoLet`, `NoHooks`, `NoSharedExamples`, `StubEnv`, `CreateOnlyNeededData`.
- rubocop-rspec cops enabled: `DescribeClass`, `ContextMethod`, `ContextWording`, `DescribedClass`, `VerifiedDoubles`.
