# frozen_string_literal: true

RSpec.describe RuboCop::Cop::EvenBetterSpecs::ExpectSyntax do
  it "flags should and should_not" do
    source = <<~RUBY
      describe User do
        it 'works' do
          response.code.should eq('200')
        end

        it { should_not be_nil }
      end
    RUBY

    expect(offenses(source)).to eq(["EvenBetterSpecs/ExpectSyntax"] * 2)
  end
end
