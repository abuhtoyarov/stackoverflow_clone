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
    # Passing factory girls attributes_for
    context 'with valid attributes' do
      it 'saves the new question to database' do
        expect(post :create, attributes_for(:question)).
          to change(Question, :count).by(1)
      end
      it 'redirect to question#show' do
        post :create, attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end
    context 'with invalid attributes' do

      it 'dont saves new question to database' do
        expect(post :create, attributes_for(:invalid_question)).
          to_not change(Question, :count)
      end
      it 'redirect to question#new' do
        post :create, attributes_for(:invalid_question)
        expect(response).to redirect_to :new
      end
    end
  end

end
