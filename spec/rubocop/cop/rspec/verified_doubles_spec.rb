# frozen_string_literal: true

RSpec.describe RuboCop::Cop::RSpec::VerifiedDoubles do
  it "flags double" do
    expect(offenses("describe User do\n  it 'x' do\n    double(:user)\n  end\nend\n")).to eq(["RSpec/VerifiedDoubles"])
  end
end
