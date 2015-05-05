require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :votable }
  it { should belong_to :user }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:points) }

  describe '#vote' do
    context 'for question' do
      let!(:question) { create(:question) }
      let(:user) { create(:user) }
      let(:vote) { build(:vote, votable: question) }

      it 'option :up should create new vote to question' do
        expect { vote.vote(user, :up) }.to change(question.votes, :count).by(1)
      end

      it 'option :up should increase score' do
        expect { vote.vote(user, :up) }.to change(question, :score).by(1)
      end

      it 'option :down should create new vote to question' do
        expect { vote.vote(user, :down) }.to change(question.votes, :count).by(1)
      end

      it 'option :down should deacrese score' do
        expect { vote.vote(user, :down) }.to change(question, :score).by(-1)
      end
    end
  end
end
