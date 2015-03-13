require 'rails_helper'

RSpec.describe Answer, type: :model do
  it 'has a valid factory' do
    expect(build(:answer)).to be_valid
  end
  it { should validate_presence_of(:body) }
  it { should belong_to(:question) }
end
