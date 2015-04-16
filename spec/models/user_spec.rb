require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }

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
end
