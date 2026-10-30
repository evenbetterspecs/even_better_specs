# frozen_string_literal: true

RSpec.describe RuboCop::Cop::EvenBetterSpecs::NoHooks do
  it "flags hooks" do
    source = <<~RUBY
      describe User do
        before { sign_in }
        after(:each) { sign_out }
      end
    RUBY

    expect(offenses(source)).to eq(["EvenBetterSpecs/NoHooks"] * 2)
  end
end
