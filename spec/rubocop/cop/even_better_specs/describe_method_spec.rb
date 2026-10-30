# frozen_string_literal: true

RSpec.describe RuboCop::Cop::EvenBetterSpecs::DescribeMethod do
  it "flags nested describes that do not name a method" do
    source = <<~RUBY
      describe UsersController, type: :request do
        describe 'GET #index' do
        end
      end
    RUBY

    expect(offenses(source)).to eq(["EvenBetterSpecs/DescribeMethod"])
  end

  it "accepts class and instance method describes" do
    source = <<~RUBY
      describe User do
        describe '#admin?' do
        end

        describe '.authenticate' do
        end
      end
    RUBY

    expect(offenses(source)).to be_empty
  end
end
