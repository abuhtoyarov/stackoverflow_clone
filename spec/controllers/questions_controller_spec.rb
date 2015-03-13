require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do  
  #Can call 'question' method to assigns :question
  let(:question) { create(:question) }

  describe 'GET #show' do
    it 'assigns the requested question to @question' do
      get :show, id: question
      expect(assigns(:question)).to eq question
    end
    it 'renders :show template' do
      get :show, id: question
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    it 'assigns new Question to @question'
    it 'renders :new template'
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
