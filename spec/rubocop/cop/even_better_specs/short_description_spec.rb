# frozen_string_literal: true

RSpec.describe RuboCop::Cop::EvenBetterSpecs::ShortDescription do
  it "flags long and multi-line descriptions" do
    source = <<~RUBY
      describe User do
        it '#{"a" * 101}' do
        end

        it 'returns 422 when first_name is missing \\
            and when last_name is missing' do
        end

        it 'returns 422' do
        end
      end
    RUBY

    expect(offenses(source)).to eq(["EvenBetterSpecs/ShortDescription"] * 2)
  end
end
