# frozen_string_literal: true

RSpec.describe RuboCop::Cop::EvenBetterSpecs::AllPossibleCases do
  it "flags a describe with a single context" do
    source = <<~RUBY
      describe ProductsController, type: :request do
        describe '#destroy' do
          context 'when the product exists' do
          end
        end
      end
    RUBY

    expect(offenses(source)).to eq(["EvenBetterSpecs/AllPossibleCases"])
  end

  it "accepts a describe with several contexts" do
    source = <<~RUBY
      describe ProductsController, type: :request do
        describe '#destroy' do
          context 'when the product exists' do
          end

          context 'when the product does not exist' do
          end
        end
      end
    RUBY

    expect(offenses(source)).to be_empty
  end
end
