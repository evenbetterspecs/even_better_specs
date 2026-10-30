# frozen_string_literal: true

RSpec.describe RuboCop::Cop::EvenBetterSpecs::CreateOnlyNeededData do
  it "flags factory lists above the max" do
    source = <<~RUBY
      describe Product do
        it 'returns the featured product' do
          create_list(:product, 5)
          create_list(:product, 3)
          FactoryBot.build_list(:product, 4)

          expect(described_class.featured_product).to be_nil
        end
      end
    RUBY

    expect(offenses(source)).to eq(["EvenBetterSpecs/CreateOnlyNeededData"] * 2)
  end
end
