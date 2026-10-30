# frozen_string_literal: true

RSpec.describe RuboCop::Cop::EvenBetterSpecs::UseSubject do
  it "flags described_class.new without arguments only" do
    source = <<~RUBY
      describe Calculator do
        it 'sums two numbers' do
          calculator = described_class.new
          subject = described_class.new(5)

          expect(calculator.add(1, 2)).to eq(subject.add(1, 2))
        end
      end
    RUBY

    expect(offenses(source)).to eq(["EvenBetterSpecs/UseSubject"])
  end

  it "accepts an example using only subject" do
    source = <<~RUBY
      describe Calculator do
        it 'sums two numbers' do
          expect(subject.add(1, 2)).to eq(3)
        end
      end
    RUBY

    expect(offenses(source)).to be_empty
  end
end
