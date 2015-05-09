require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:user_id) }
  it { should validate_length_of(:title).is_at_least(15).is_at_most(255) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to(:user) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should accept_nested_attributes_for(:attachments) }
  it { should have_many(:votes).dependent(:destroy) }

  describe '#score' do
    let!(:question) { create(:question_with_votes) }
    let!(:vote) { create(:vote, points: -1, votable: question) }
    it 'should show correct total points' do
      expect(question.score).to eq 2
    end
  end
end
