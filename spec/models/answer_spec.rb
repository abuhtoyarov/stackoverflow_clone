require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:user_id) }
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should have_many(:attachments) }
  it { should accept_nested_attributes_for(:attachments) }

  describe '#accept' do
    let!(:question) { create(:question_with_answers) }
    let!(:answer) { create(:answer, question: question) }
    let!(:old_accepted_answer) { create(:answer, question: question, accepted: true) }
    before { answer.accept }

    it 'should change answer to accepted' do
      expect(answer.accepted?).to eq true
    end

    it 'should accept only one answer' do
      expect(question.answers.where(accepted: true).count).to eq 1
    end

    it 'should make accepted answer to be first in by_rating scope' do
      expect(question.answers.by_rating.first).to eq answer
    end
  end
end
