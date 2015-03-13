require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do  
  #Can call 'question' method to assigns :question
  let(:question) { create(:question) }

  describe 'GET #show' do
    before { get :show, id: question }
    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end
    it 'renders :show template' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { get :new }
    it 'assigns new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end
    it 'renders :new template' do
      expect(response).to render_template :new
    end
  end
  
  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new question to database'
      it 'redirect to question#show'
    end
    context 'with invalid attributes' do
      it 'dont saves new question to database'
      it 'redirect to question#new'
    end
  end

end
