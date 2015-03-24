require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do  
  #Can call 'question' method to assigns :question
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  describe 'GET #index' do
    before {get :index}
    it 'populates an array of questions' do
      expect(assigns(:questions)).to match_array [question]
    end
    it 'renders :index template' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, id: question }
    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end
    it 'assigns the new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end
    it 'populates an array of answers' do
      expect(assigns(:answers)).to match_array [answer]
    end
    it 'renders :show template' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user
    before { get :new }
    it 'assigns new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end
    it 'renders :new template' do
      expect(response).to render_template :new
    end
  end
  
  describe 'POST #create' do
    sign_in_user
    # Passing factory girls attributes_for
    # this attributes must be in question: hash for strong params
    context 'with valid attributes' do
      it 'saves the new question to database' do

        expect { post :create, question: attributes_for(:question) }.
          to change(Question, :count).by(1)
      end
      it 'redirect to question#show' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'dont saves new question to database' do
        expect { post :create, question: attributes_for(:invalid_question) }.
          to_not change(Question, :count)
      end
      it 'redirect to question#new' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    
    let!(:question_with_answer) { create(:question_with_answer, user_id: @user.id) }
    let!(:question) { create(:question, user_id: @user.id) }
    let!(:another_user_question) { create(:question) }

    context 'User can delete his own question without answers' do
      it 'delete question from database' do
        expect { delete :destroy, id: question }.
          to change(Question, :count).by(-1)
      end
      it 'redirect to questions index' do
        delete :destroy, id: question
        expect(response).to redirect_to questions_path
      end
    end

    context 'User cant delete his own question with answers' do
      
      it 'not delete question from database' do
        expect { delete :destroy, id: question_with_answer }.
          to_not change(Question, :count)
      end
      it 'redirect to question' do
        delete :destroy, id: question_with_answer
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'User cant delete not his own question' do
      it 'not delete question from database' do
        expect { delete :destroy, id: another_user_question }.
          to_not change(Question, :count)
      end

      it 'redirect to question' do
        delete :destroy, id: another_user_question
        expect(response).to redirect_to assigns(:question)
      end
    end
  end

end
