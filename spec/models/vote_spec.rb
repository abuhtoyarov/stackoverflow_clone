require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :votable }
  it { should belong_to :user }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:points) }

  let(:question) { create(:question) }
  let(:answer) { create(:answer) }
  let(:user) { create(:user) }

  describe '#vote' do
    [:question, :answer].each do |resource|
      before { @resource = send resource }
      let(:vote) { build(:vote, votable: @resource) }
      context "for #{resource}" do
        it 'option :up should create new vote' do
          expect { vote.vote(user, :up) }.to change(@resource.votes, :count).by(1)
        end

        it 'option :up should increase score' do
          expect { vote.vote(user, :up) }.to change(@resource, :score).by(1)
        end

        it 'option :down should create new vote' do
          expect { vote.vote(user, :down) }.to change(@resource.votes, :count).by(1)
        end

        it 'option :down should deacrese score' do
          expect { vote.vote(user, :down) }.to change(@resource, :score).by(-1)
        end
      end
    end
  end
end
