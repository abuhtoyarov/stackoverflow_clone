require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves the new answer to database' do
        # this genereate expected request i.e.:
        # {:action=>"create", :answer=>{:body=>"MyString"},
        # :controller=>"answers", :question_id=>"193"}
        expect { 
          post :create,
          answer: attributes_for(:answer),
          question_id: question
        }.to change(question.answers, :count).by(1)
      end
      it 'redirect to question #show' do
        post :create, answer: attributes_for(:answer), question_id: question
        expect(response).to redirect_to(question)
      end
    end

    context 'with invalid attributes' do
      it 'dont save answer to database' do
        expect { 
          post :create,
          answer: attributes_for(:invalid_answer),
          question_id: question
        }.to_not change(Answer, :count)
      end
      it 'render question #show' do
        post( 
          :create, 
          answer: attributes_for(:invalid_answer), 
          question_id: question
        )
        expect(response).to render_template 'questions/show'
      end
      it 'populates an array of answers' do
        post(
          :create, 
          answer: attributes_for(:invalid_answer), 
          question_id: question
        )
        expect(assigns(:answers)).to match_array [answer]
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    let!(:answer) { create(:answer, question: question, user_id: @user.id) }
    let!(:another_user_answer) { create(:question) }

    context 'answers owner' do
      it 'delete answer from database' do
        expect { delete :destroy, id: answer, question_id: question }.
          to change(Answer, :count).by(-1)
      end
      it 'redirect to question path' do
        delete :destroy, id: answer, question_id: question
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'another auth user' do
      let!(:answer) { create(:answer, question: question) }
      
      it 'not delete answer from database' do
        expect { delete :destroy, id: answer, question_id: question }.
          to_not change(Answer, :count)
      end

      it 'redirect to question path' do
        delete :destroy, id: answer, question_id: question
        expect(response).to redirect_to question_path(assigns(:question))
      end
      
    end
  end

end
