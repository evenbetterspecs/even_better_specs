# frozen_string_literal: true

RSpec.describe RuboCop::Cop::EvenBetterSpecs::NoSharedExamples do
  it "flags shared examples and shared contexts" do
    source = <<~RUBY
      describe User do
        shared_examples 'a user' do
        end
        it_behaves_like 'a user'
        include_context 'logged in'
      end
    RUBY

    expect(offenses(source)).to eq(["EvenBetterSpecs/NoSharedExamples"] * 3)
  end
end
