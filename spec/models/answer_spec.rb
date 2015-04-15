require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:user_id) }
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  describe '#accept_answer' do
    let!(:question) { create(:question_with_answers) }
    let!(:answer) { create(:answer, question: question) }
    before do
      # accept some answer before testing
      question.answers.take.accept
      answer.accept
    end

    it 'should change answer to accepted' do
      expect(answer.is_accepted).to eq true
    end

    it 'should accept only one answer' do
      expect(question.answers.where(is_accepted: true).count).to eq 1
    end

    it 'should make accepted answer to be first in by_rating scope' do
      expect(question.answers.by_rating.first).to eq answer
    end
  end
end
