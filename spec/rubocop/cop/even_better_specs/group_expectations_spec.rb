# frozen_string_literal: true

RSpec.describe RuboCop::Cop::EvenBetterSpecs::GroupExpectations do
  it "flags sibling examples with the same setup" do
    source = <<~RUBY
      describe UsersController, type: :request do
        it 'returns 200' do
          get user_path(1)

          expect(response.code).to eq('200')
        end

        it 'returns JSON content type' do
          get user_path(1)

          expect(response.content_type).to eq('application/json')
        end

        it 'returns 404' do
          get user_path(2)

          expect(response.code).to eq('404')
        end
      end
    RUBY

    expect(offenses(source)).to eq(["EvenBetterSpecs/GroupExpectations"])
  end

  it "flags every repeated sibling after the first one" do
    source = <<~RUBY
      describe UsersController, type: :request do
        it 'returns 200' do
          get users_path

          expect(response.code).to eq('200')
        end

        it 'returns JSON content type' do
          get users_path

          expect(response.content_type).to eq('application/json')
        end

        it 'returns an empty list' do
          get users_path

          expect(response.parsed_body).to eq([])
        end
      end
    RUBY

    expect(offenses(source)).to eq(["EvenBetterSpecs/GroupExpectations"] * 2)
  end

  it "flags repeated multi-statement setups" do
    source = <<~RUBY
      describe User do
        describe '#full_name' do
          it 'starts with the first name' do
            user = build(:user, first_name: 'Ayrton', last_name: 'Senna')

            full_name = user.full_name

            expect(full_name).to start_with('Ayrton')
          end

          it 'ends with the last name' do
            user = build(:user, first_name: 'Ayrton', last_name: 'Senna')

            full_name = user.full_name

            expect(full_name).to end_with('Senna')
          end
        end
      end
    RUBY

    expect(offenses(source)).to eq(["EvenBetterSpecs/GroupExpectations"])
  end

  it "accepts the same setup in different contexts" do
    source = <<~RUBY
      describe UsersController, type: :request do
        describe '#index' do
          context 'when logged in' do
            it 'returns 200' do
              get users_path

              expect(response.code).to eq('200')
            end
          end

          context 'when logged out' do
            it 'returns 401' do
              get users_path

              expect(response.code).to eq('401')
            end
          end
        end
      end
    RUBY

    expect(offenses(source)).to be_empty
  end

  it "accepts examples that only contain expectations" do
    source = <<~RUBY
      describe Calculator do
        it { is_expected.to respond_to(:add) }
        it { is_expected.to respond_to(:subtract) }
      end
    RUBY

    expect(offenses(source)).to be_empty
  end

  it "accepts expectations grouped in a single example" do
    source = <<~RUBY
      describe UsersController, type: :request do
        it 'responds with 200 http status and a JSON content type' do
          get users_path

          expect(response.code).to eq('200')
          expect(response.content_type).to eq('application/json')
        end
      end
    RUBY

    expect(offenses(source)).to be_empty
  end

  it "accepts setups acting inside an expect block" do
    source = <<~RUBY
      describe UsersController, type: :request do
        it 'creates a user' do
          expect { post users_path, params: { name: 'Tom' } }.to change(User, :count).by(1)
        end

        it 'enqueues a welcome email' do
          expect { post users_path, params: { name: 'Tom' } }.to have_enqueued_mail(UserMailer, :welcome)
        end
      end
    RUBY

    expect(offenses(source)).to be_empty
  end
end
