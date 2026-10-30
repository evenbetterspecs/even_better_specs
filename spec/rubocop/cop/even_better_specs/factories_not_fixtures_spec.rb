# frozen_string_literal: true

RSpec.describe RuboCop::Cop::EvenBetterSpecs::FactoriesNotFixtures do
  it "flags fixtures" do
    expect(offenses("describe User do\n  fixtures :users\nend\n")).to eq(["EvenBetterSpecs/FactoriesNotFixtures"])
  end

  it "flags fixtures :all" do
    expect(offenses("describe User do\n  fixtures :all\nend\n")).to eq(["EvenBetterSpecs/FactoriesNotFixtures"])
  end

  it "flags fixtures with several tables" do
    expect(offenses("describe User do\n  fixtures :users, :products\nend\n")).to eq(["EvenBetterSpecs/FactoriesNotFixtures"])
  end

  it "flags fixtures in nested groups" do
    source = <<~RUBY
      describe User do
        describe '#full_name' do
          fixtures :users

          it 'returns the full name' do
            expect(users(:santos).full_name).to eq('Santos Dumont')
          end
        end
      end
    RUBY

    expect(offenses(source)).to eq(["EvenBetterSpecs/FactoriesNotFixtures"])
  end

  it "accepts factories" do
    source = <<~RUBY
      describe User do
        describe '#full_name' do
          it 'returns the full name' do
            user = build_stubbed(:user, first_name: 'Santos', last_name: 'Dumont')

            expect(user.full_name).to eq('Santos Dumont')
          end
        end
      end
    RUBY

    expect(offenses(source)).to be_empty
  end

  it "accepts fixtures called on another receiver" do
    source = <<~RUBY
      describe Importer do
        describe '#fixtures' do
          it 'returns the fixtures' do
            importer = instance_double(described_class, fixtures: [])

            expect(importer.fixtures).to eq([])
          end
        end
      end
    RUBY

    expect(offenses(source)).to be_empty
  end
end
