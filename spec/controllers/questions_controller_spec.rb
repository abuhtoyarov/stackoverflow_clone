require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  
  describe 'GET #show' do
    it 'assigns the requested question to @question'
    it 'renders :show template'
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
