# Even Better Specs

RuboCop cops for the [Even Better Specs](https://evenbetterspecs.github.io) guidelines, with a CLI
that runs in any project, including Rails apps that do not have `rubocop` in their Gemfile.

## Usage

Install the gem globally (do **not** add it to the Gemfile) and run it from the project root:

```sh
gem install even_better_specs
even_better_specs            # checks every *_spec.rb
even_better_specs spec/models
even_better_specs -a         # autocorrect what can be autocorrected
```

Do not use `bundle exec`, because the gem is not in the Gemfile. The CLI accepts all `rubocop` options.
It runs with its own config only, so the project's `.rubocop.yml` (if any) is ignored.

## Rules

| Guideline | Cop |
|---|---|
| Describe what you are testing | `RSpec/DescribeClass`, `EvenBetterSpecs/DescribeMethod` |
| Use contexts | `RSpec/ContextMethod`, `RSpec/ContextWording` (`when`) |
| Factories, not fixtures | `EvenBetterSpecs/FactoriesNotFixtures` |
| Leverage described class | `RSpec/DescribedClass` |
| Use subject | `EvenBetterSpecs/UseSubject` |
| Short description | `EvenBetterSpecs/ShortDescription` (`Max: 100`) |
| Group expectations | `EvenBetterSpecs/GroupExpectations` |
| All possible cases | `EvenBetterSpecs/AllPossibleCases` (flags a `describe` with a single `context`; reported as `info`, so it does not fail the run) |
| Request vs controller specs | `EvenBetterSpecs/RequestSpecs` |
| Expect vs should syntax | `EvenBetterSpecs/ExpectSyntax` |
| Redundant require | `EvenBetterSpecs/RedundantRequire` (autocorrectable) |
| Instance double over double | `RSpec/VerifiedDoubles` |
| Let's not | `EvenBetterSpecs/NoLet` |
| Avoid hooks | `EvenBetterSpecs/NoHooks` |
| Don't use shared examples | `EvenBetterSpecs/NoSharedExamples` |
| Stub environment variables | `EvenBetterSpecs/StubEnv` (flags writes to `ENV`) |
| Create only the data you need | `EvenBetterSpecs/CreateOnlyNeededData` (`*_list` above `Max: 2`) |

"Mock external dependencies" and "Stub HTTP requests" cannot be detected statically. For HTTP, use
`WebMock.disable_net_connect!` in `spec_helper.rb` so unstubbed requests fail.

## Development

```sh
bundle install
bundle exec rspec
```
