# frozen_string_literal: true

RSpec.describe RuboCop::Cop::RSpec::ContextMethod do
  it "flags context with a method name" do
    source = <<~RUBY
      describe User do
        context '#admin?' do
        end
      end
    RUBY

    expect(offenses(source)).to include("RSpec/ContextMethod")
  end
end
