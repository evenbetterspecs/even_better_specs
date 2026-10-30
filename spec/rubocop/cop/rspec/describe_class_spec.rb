# frozen_string_literal: true

RSpec.describe RuboCop::Cop::RSpec::DescribeClass do
  it "flags a string top-level describe in request specs" do
    expect(offenses("describe '/users', type: :request do\nend\n")).to eq(["RSpec/DescribeClass"])
  end

  it "accepts the controller constant in request specs" do
    expect(offenses("describe UsersController, type: :request do\nend\n")).to be_empty
  end
end
