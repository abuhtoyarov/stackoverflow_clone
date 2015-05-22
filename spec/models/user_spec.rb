require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:authorizations) }

  describe '#owner?' do
    let!(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, user: user) }
    let(:another_question) { create(:question) }
    let(:another_answer) { create(:answer) }

    it 'with his question' do
      expect(user.owner?(question)).to eq true
    end

    it 'with his answer' do
      expect(user.owner?(answer)).to eq true
    end

    it 'with another person question' do
      expect(user.owner?(another_question)).to eq false
    end

    it 'with another person answer' do
      expect(user.owner?(another_answer)).to eq false
    end
  end

  describe '#can_vote?' do
    let!(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:user_question) { create(:question, user: user) }
    let!(:voted_question) { create(:question) }
    let!(:vote) { create(:vote, user: user, votable: voted_question) }

    it 'with another unvoted user question' do
      expect(user.can_vote?(question)).to eq true
    end

    it 'with his question' do
      expect(user.can_vote?(user_question)).to eq false
    end

    it 'with priviosly self voted question' do
      expect(user.can_vote?(voted_question)).to eq false
    end
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123123') }

    context 'user already has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '123123')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has not authorization' do
      context 'already exists' do
        let(:auth) {
          OmniAuth::AuthHash.new(provider: 'facebook',
                                 uid: '123123',
                                 info: { email: user.email })
        }

        it 'does not create new user' do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect { User.find_for_oauth(auth) }.to change(Authorization, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first
          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end
    end

    context 'does not exists' do
      let(:auth) {
        OmniAuth::AuthHash.new(provider: 'facebook',
                               uid: '123123',
                               info: { email: 'user@email.com' })
      }

      it 'creates new user' do
        expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
      end

      it 'returns new user' do
        expect(User.find_for_oauth(auth)).to be_a(User)
      end

      it 'fills user email' do
        user = User.find_for_oauth(auth)
        expect(user.email).to eq auth.info[:email]
      end

      it 'creates authorization for user' do
        user = User.find_for_oauth(auth)
        expect(user.authorizations).to_not be_empty
      end

      it 'creates authorization with provider and uid' do
        authorization = User.find_for_oauth(auth).authorizations.first
        expect(authorization.provider).to eq auth.provider
        expect(authorization.uid).to eq auth.uid
      end
    end
  end

  context 'provider has not email' do
    let(:auth) { OmniAuth::AuthHash.new(provider: 'twitter', uid: '123456') }

    it 'returns nil' do
      expect(User.find_for_oauth(auth)).to be nil
    end
  end
end
