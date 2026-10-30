# frozen_string_literal: true

RSpec.describe RuboCop::Cop::EvenBetterSpecs::RequestSpecs do
  it "flags controller specs" do
    expect(offenses("describe UsersController, type: :controller do\nend\n")).to eq(["EvenBetterSpecs/RequestSpecs"])
  end

  it "accepts request specs" do
    expect(offenses("describe UsersController, type: :request do\nend\n")).to be_empty
  end
end
