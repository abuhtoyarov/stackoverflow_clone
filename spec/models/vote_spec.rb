require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :votable }
  it { should belong_to :user }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:points) }

  describe '#voteup' do
    context 'for question' do
      let!(:question) { create(:question) }
      let(:user) { create(:user) }
      let(:vote) { build(:vote, votable: question) }

      it 'should create new vote to question' do
        expect { vote.voteup(user) }.to change(question.votes, :count).by(1)
      end

      it 'should increase score' do
        expect { vote.voteup(user) }.to change(question, :score).by(1)
      end
    end
  end
end
