# frozen_string_literal: true

RSpec.describe RuboCop::Cop::RSpec::DescribedClass do
  it "flags the class name inside its own describe" do
    source = <<~RUBY
      describe Pilot do
        it 'returns the most successful pilot' do
          expect(Pilot.most_successful).to be_nil
        end
      end
    RUBY

    expect(offenses(source)).to eq(["RSpec/DescribedClass"])
  end
end
