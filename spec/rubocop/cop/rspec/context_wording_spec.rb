# frozen_string_literal: true

RSpec.describe RuboCop::Cop::RSpec::ContextWording do
  it "flags contexts not starting with when" do
    source = <<~RUBY
      describe User do
        context 'if logged in' do
        end

        context 'when logged out' do
        end
      end
    RUBY

    expect(offenses(source)).to eq(["RSpec/ContextWording"])
  end
end
