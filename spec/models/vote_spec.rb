require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :votable }
  it { should belong_to :user }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:points) }
  it { should validate_uniqueness_of(:user_id).scoped_to([:votable_id, :votable_type]) }

  let(:question) { create(:question) }
  let(:answer) { create(:answer) }
  let(:user) { create(:user) }

  describe '#up and #down' do
    [:question, :answer].each do |resource|
      before { @resource = send resource }
      let(:vote) { build(:vote, votable: @resource) }
      context "for #{resource}" do
        it '#up should create new vote' do
          expect { vote.up(user) }.to change(@resource.votes, :count).by(1)
        end

        it '#up should increase score' do
          expect { vote.up(user) }.to change(@resource, :score).by(1)
        end

        it '#down should create new vote' do
          expect { vote.down(user) }.to change(@resource.votes, :count).by(1)
        end

        it '#down should deacrese score' do
          expect { vote.down(user) }.to change(@resource, :score).by(-1)
        end
      end
    end
  end
end
