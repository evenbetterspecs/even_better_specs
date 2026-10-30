# frozen_string_literal: true

RSpec.describe RuboCop::Cop::EvenBetterSpecs::StubEnv do
  it "flags writes to ENV but not reads" do
    source = <<~RUBY
      describe Mailer do
        it 'prepares the email' do
          ENV['SALES_TEAM_EMAIL'] = 'sales@company.com'

          expect(ENV['SALES_TEAM_EMAIL']).to eq('sales@company.com')
        end
      end
    RUBY

    expect(offenses(source)).to eq(["EvenBetterSpecs/StubEnv"])
  end

  it "flags writes to ::ENV" do
    source = <<~RUBY
      describe Mailer do
        it 'prepares the email' do
          ::ENV['SALES_TEAM_EMAIL'] = 'sales@company.com'
        end
      end
    RUBY

    expect(offenses(source)).to eq(["EvenBetterSpecs/StubEnv"])
  end

  it "flags ENV mutating methods" do
    source = <<~RUBY
      describe Mailer do
        it 'prepares the email' do
          ENV.store('SALES_TEAM_EMAIL', 'sales@company.com')
          ENV.update('SALES_TEAM_EMAIL' => 'sales@company.com')
          ENV.merge!('SALES_TEAM_EMAIL' => 'sales@company.com')
          ENV.delete('SALES_TEAM_EMAIL')
          ENV.replace({})
          ENV.clear
        end
      end
    RUBY

    expect(offenses(source)).to eq(["EvenBetterSpecs/StubEnv"] * 6)
  end

  it "accepts stub_env" do
    source = <<~RUBY
      describe Mailer do
        it 'prepares the email' do
          stub_env('SALES_TEAM_EMAIL', 'sales@company.com')

          expect(ENV.fetch('SALES_TEAM_EMAIL')).to eq('sales@company.com')
        end
      end
    RUBY

    expect(offenses(source)).to be_empty
  end

  it "accepts reading ENV" do
    source = <<~RUBY
      describe Mailer do
        it 'reads the environment' do
          expect(ENV.key?('SALES_TEAM_EMAIL')).to be(true)
          expect(ENV.fetch('SALES_TEAM_EMAIL', nil)).to be_nil
          expect(ENV.to_h).to include('PATH')
        end
      end
    RUBY

    expect(offenses(source)).to be_empty
  end

  it "accepts writes to other hashes" do
    source = <<~RUBY
      describe Mailer do
        it 'builds the headers' do
          headers = {}

          headers['SALES_TEAM_EMAIL'] = 'sales@company.com'

          expect(headers).to eq('SALES_TEAM_EMAIL' => 'sales@company.com')
        end
      end
    RUBY

    expect(offenses(source)).to be_empty
  end
end
