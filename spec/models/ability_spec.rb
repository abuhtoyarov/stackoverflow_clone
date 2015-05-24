require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest user' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin user' do
    let(:user) { create(:admin) }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let!(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:user_question) { create(:question, user: user) }
    let(:answer_in_user_question) { create(:answer, question: user_question) }
    let(:answer) { create(:answer) }
    let(:user_answer) { create(:answer, user: user) }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, user_question, user: user }
    it { should_not be_able_to :update, question, user: user }

    it { should be_able_to :destroy, user_question, user: user }
    it { should_not be_able_to :destroy, question, user: user }

    it { should be_able_to :update, user_answer, user: user }
    it { should_not be_able_to :update, answer, user: user }

    it { should be_able_to :destroy, user_answer, user: user }
    it { should_not be_able_to :destroy, answer, user: user }

    it { should be_able_to :accept, answer_in_user_question, user: user }
    it { should_not be_able_to :accept, answer, user: user }

    it { should be_able_to :vote_up, answer, user: user }
    it { should be_able_to :vote_down, answer, user: user }
    it { should be_able_to :unvote, answer, user: user }
    it { should be_able_to :unvote, user_answer, user: user }
    it { should be_able_to :vote_up, question, user: user }
    it { should be_able_to :vote_down, question, user: user }
    it { should be_able_to :unvote, question, user: user }
    it { should be_able_to :unvote, user_question, user: user }

    it { should_not be_able_to :vote_up, user_answer, user: user }
    it { should_not be_able_to :vote_down, user_answer, user: user }
    it { should_not be_able_to :vote_up, user_question, user: user }
    it { should_not be_able_to :vote_down, user_question, user: user }
  end
end
