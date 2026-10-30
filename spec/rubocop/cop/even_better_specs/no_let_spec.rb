# frozen_string_literal: true

RSpec.describe RuboCop::Cop::EvenBetterSpecs::NoLet do
  it "flags let and let!" do
    source = <<~RUBY
      describe User do
        let(:user) { build(:user) }
        let!(:admin) { create(:user) }
      end
    RUBY

    expect(offenses(source)).to eq(["EvenBetterSpecs/NoLet"] * 2)
  end

  it "flags let in nested groups" do
    source = <<~RUBY
      describe User do
        describe '#full_name' do
          let(:user) { build(:user, first_name: 'Edson', last_name: nil) }

          it 'returns the first name' do
            expect(user.full_name).to eq('Edson')
          end
        end
      end
    RUBY

    expect(offenses(source)).to eq(["EvenBetterSpecs/NoLet"])
  end

  it "flags let with a do...end block" do
    source = <<~RUBY
      describe User do
        let(:user) do
          build(:user)
        end
      end
    RUBY

    expect(offenses(source)).to eq(["EvenBetterSpecs/NoLet"])
  end

  it "flags let overriding an outer let" do
    source = <<~RUBY
      describe User do
        let(:name) { 'Edson' }

        context 'when the name is blank' do
          let(:name) { '' }
        end
      end
    RUBY

    expect(offenses(source)).to eq(["EvenBetterSpecs/NoLet"] * 2)
  end

  it "accepts data defined inside the example" do
    source = <<~RUBY
      describe User do
        describe '#full_name' do
          it 'returns the full name' do
            user = build(:user, first_name: 'Edson', last_name: 'Pelé')

            expect(user.full_name).to eq('Edson Pelé')
          end
        end
      end
    RUBY

    expect(offenses(source)).to be_empty
  end

  it "accepts let called on another receiver" do
    source = <<~RUBY
      describe Lease do
        describe '#let' do
          it 'lets the property' do
            subject.let(:apartment)

            expect(subject).to be_let
          end
        end
      end
    RUBY

    expect(offenses(source)).to be_empty
  end
end
