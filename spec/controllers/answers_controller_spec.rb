require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new post to database' do
      end
    end

  end
end
